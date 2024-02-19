class UserStatisticBuilderService < BaseService
  def initialize(params:)
    @reservation_id = 6#params[:reservation_id]
    @left_at = DateTime.now
    # @customer_id = params[:customer_id]
  end

  def call
    create_table_statistic
    Result.new(success: true, output: {})
  end

  private

  def create_table_statistic
    ActiveRecord::Base.connection.execute <<-SQL
      INSERT INTO table_statistics (customer_id, dishes_count, total_bill_cents, time_spent_seconds)
      SELECT
        r.client_id AS customer_id,
        COALESCE(SUM(o.quantity), 0) AS dishes_count,
        COALESCE(SUM(mi.price_cents * o.quantity), 0) AS total_bill_cents,
        EXTRACT(EPOCH FROM (#{@left_at} - r.starts_at)) AS time_spent_seconds
      FROM
        reservations r
      LEFT JOIN
        orders o ON r.id = o.reservation_id
      LEFT JOIN
          menu_items mi ON o.menu_item_id = mi.id
      WHERE
        r.id = #{@reservation_id}
      GROUP BY
        r.client_id;
    SQL
  end
end
