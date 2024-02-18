class BaseService
  INTERNAL_SERVER_ERR = 'Something went wrong'

  class Result < Struct.new(:success, :output, :error_msg, :status, keyword_init: true)
    def success?
      !!self.success
    end
  end
  class ToLateToReserveError < StandardError; end
  class WrongTimesError < StandardError; end
  class ReservationOverlapError < StandardError; end
  class UserMissingError < StandardError; end
end
