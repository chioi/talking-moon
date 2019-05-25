# frozen_string_literal: true

require_relative 'response_creator'

module Sinatra
  module ChatServer
    module Helpers
      def read_request_body(attribute)
        env['parsed_body'][attribute]
      end

      def set_default_response_content_type(type = ACCEPTED_CONTENT_TYPE)
        content_type type
      end

      def reject_invalid_request_content_type
        unless request.content_type == ACCEPTED_CONTENT_TYPE
          immediately_send_errors 415
        end
      end

      def immediately_send_errors(code, errors = [])
        response_body = JSONAPI::ResponseBuilder.build(code, errors)
        halt [code, {}, response_body.to_json]
      end
    end
  end
end
