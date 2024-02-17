class BaseService
  class Result < Struct.new(:success, :output, :error_msg, :status, keyword_init: true)
    def success?
      self.success == true
    end
  end
end
