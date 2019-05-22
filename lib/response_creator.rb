# frozen_string_literal: true

require 'jsonable'

class ErrorResponse < JSONable
  def initialize(errors)
    @errors = errors
  end
end

class SuccessResponse < JSONable
  def initialize(data)
    @data = data
  end
end

class ResponseCreator
  def self.createWithErrors(errors)
    ErrorResponse.new errors
  end

  def self.createWithData(data)
    SuccessResponse.new data
  end
end
