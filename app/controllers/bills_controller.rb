class BillsController < ApplicationController
  def create
    result = UserStatisticBuilderService.new(params: bill_params).call

    if result.success?
      render json: result.output.as_json, status: result.status
    else
      render json: { message: result.error_msg }, status: result.status
    end
  end

  private

  def bill_params
    params.require(%i[reservation_id])
    params.permit(%i[reservation_id])
  end
end
