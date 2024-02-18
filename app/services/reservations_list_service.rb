class ReservationsListService < BaseService
  def call
    load_tables
    load_grouped_reservations
    enrich_tables
    Result.new(success: true, output: @tables.as_json, status: 200)
  rescue JSON::ParserError, Errno::ENOENT
    Result.new(success: false, status: 500, error_msg: INTERNAL_SERVER_ERR)
  end

  private

  def enrich_tables
    @tables.each do |k, v|
      v[:reservations] = @grouped_reservations[k].to_a
    end
  end

  def load_grouped_reservations
    @grouped_reservations =
      Reservation.where('ends_at > ?', DateTime.now)
        .where(table_id: @tables.keys)
        .group_by { |reservation| reservation.table_id.to_s }
  end

  def load_tables
    @tables = Table.instance.all
  end
end
