class ReservationsController < ApplicationController
  def create
    # binding.pry
    result = CreateReservationService.new(params: reservation_params).call

    if result.success?
      render json: result.output, status: result.status
    else
      render json: { message: result.error_msg }, status: result.status
    end
  end

  def index
    #
  end

  private

  def reservation_params
    params.require(%i[client_id table_id starts_at ends_at])
    params.permit(:client_id, :table_id, :starts_at, :ends_at,
      orders_attributes: [
        :quantity,
        :menu_item_id
      ]
    )
  end
end
