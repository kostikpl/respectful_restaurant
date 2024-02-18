class BaseService
  class Result < Struct.new(:success, :output, :error_msg, :status, keyword_init: true)
    def success?
      self.success == true
    end
  end
  class ToLateToReserveError < StandardError; end
  class WrongTimesError < StandardError; end
  class ReservationOverlapError < StandardError; end
  class UserMissingError < StandardError; end
end
