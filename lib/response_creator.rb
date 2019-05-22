# frozen_string_literal: true

require_relative 'jsonable'

class JSONAPIResponse < JSONable
  def initialize(type_of_content, content)
    instance_variable_set "@#{type_of_content}", content
  end
end

class ResponseCreator
  def self.createWithErrors(errors)
    JSONAPIResponse.new 'errors', errors
  end

  def self.createWithData(data)
    JSONAPIResponse.new 'data', data
  end
end
