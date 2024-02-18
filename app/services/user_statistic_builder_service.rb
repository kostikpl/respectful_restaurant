class UserStatisticBuilderService < BaseService
  def initialize(params:)
    @reservation_id = params[:reservation_id]
    @left_at = DateTime.now
    @customer_id = params[:customer_id]
  end

  def call
    #
  end

  private
end
