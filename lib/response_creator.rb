# frozen_string_literal: true

require_relative 'jsonable'

module JSONAPI
  class Error404 < JSONable
    def initialize
      @status = 404
      @title = 'The resource could not be found'
      @detail = 'Either the resource does not exist or' \
      ' the route you queried does not exist'
    end
  end

  class Error415 < JSONable
    def initialize
      @status = 415
      @title = 'Unsupported media type'
      @detail = 'This API only accepts requests with' \
      "#{ENV['ACCEPTED_CONTENT_TYPE']} `Content-Type`."
    end
  end

  class Response < JSONable
    def initialize(type_of_content, entities)
      instance_variable_set "@#{type_of_content}", entities
    end
  end

  class ResponseBuilder
    def self.buildWithData(data)
      JSONAPI::Response.new 'data', data
    end

    def self.buildWithErrors(errors)
      JSONAPI::Response.new 'errors', errors
    end

    def self.build(code, entities = [])
      case code
      when 404
        buildWithErrors [JSONAPI::Error404.new].concat(entities)
      when 415
        buildWithErrors [JSONAPI::Error415.new].concat(entities)
    end
    end
  end
end
