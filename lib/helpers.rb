# frozen_string_literal: true

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
        halt [code, {}, ResponseCreator.createWithErrors(errors).to_json]
      end
    end
  end
end
