class UserStatisticBuilderService < BaseService
  def initialize(params:)
    @reservation_id = params[:reservation_id].to_i
    @left_at = DateTime.now
  end

  def call
    # client is asking for a bill and we're calculating stats
    # maybe later on we'll rename service and extend it with additional
    # functionality like giving tips, top up restaurant balance
    create_table_statistic
    Result.new(success: true, output: {}, status: 201)
  rescue => e
    Result.new(success: false, status: 500, error_msg: INTERNAL_SERVER_ERR)
  end

  private

  def create_table_statistic
    ActiveRecord::Base.connection.execute <<-SQL
      INSERT INTO table_statistics (customer_id, dishes_count, total_bill_cents, time_spent_seconds)
      SELECT
        r.client_id AS customer_id,
        COALESCE(SUM(o.quantity), 0) AS dishes_count,
        COALESCE(SUM(mi.price_cents * o.quantity), 0) AS total_bill_cents,
        EXTRACT(EPOCH FROM ('#{@left_at}' - r.starts_at)) AS time_spent_seconds
      FROM
        reservations r
      LEFT JOIN
        orders o ON r.id = o.reservation_id
      LEFT JOIN
          menu_items mi ON o.menu_item_id = mi.id
      WHERE
        r.id = #{@reservation_id}
      GROUP BY
        r.client_id, r.starts_at;
    SQL
  end
end
