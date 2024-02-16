class UsersController < ApplicationController
  def show
    result = UserIdentifierService.new(params: user_params).call

    if result.success?
      render json: result.output.as_json, status: result.status
    else
      render json: { message: result.error_msg }, status: result.status
    end
  end

  def user_params
    params.require(%i[first_name last_name])
    params.permit(%i[first_name last_name])
  end
end
