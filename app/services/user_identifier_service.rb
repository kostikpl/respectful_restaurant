class UserIdentifierService < BaseService
  class UserMissingError < StandardError; end

  USERS_FILE_PATH = Rails.root.join('json_data/users.json')
  INTERNAL_SERVER_ERR = 'Something went wrong'
  NOT_FOUND = 'Not found'

  def initialize(params:)
    @first_name = params[:first_name]
    @last_name = params[:last_name]
  end

  def call
    load_users
    load_user_id
    Result.new(success: true, output: { id: @user_id }, status: 200)
  rescue UserMissingError => e
    Result.new(success: false, status: 404, error_msg: e.message)
  rescue JSON::ParserError, Errno::ENOENT
    Result.new(success: false, status: 500, error_msg: INTERNAL_SERVER_ERR)
  end

  private

  def load_users
    @users = JSON.parse(File.read(USERS_FILE_PATH))
  end

  def load_user_id
    @user_id =
      @users.key(
        {
          "firstName"=> @first_name,
          "lastName"=> @last_name
        }
      )
    raise UserMissingError.new(NOT_FOUND) unless @user_id
  end
end
