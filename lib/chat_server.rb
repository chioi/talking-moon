# frozen_string_literal: true

require 'dotenv'
require 'sinatra/base'
require 'rack/bodyparser'
require_relative 'helpers'
require_relative 'message_store'

require 'sinatra/reloader' if ENV['APP_ENV'] == 'development'
Dotenv.load(".env.#{ENV['APP_ENV']}")
ACCEPTED_CONTENT_TYPE = ENV['ACCEPTED_CONTENT_TYPE']

module ChatServer
  class App < Sinatra::Base
    def initialize
      super
      @store = MessageStore.new({})
    end

    set :bind, '0.0.0.0'

    use Rack::BodyParser, parsers: {
      ACCEPTED_CONTENT_TYPE => proc { |data| JSON.parse data }
    }

    helpers Sinatra::ChatServer::Helpers

    before do
      reject_invalid_request_content_type
      set_default_response_content_type
    end

    post "#{ENV['API_URL']}/messages" do
      message = Message.from_hash env['parsed_body']
      @store.save message
      status 204
    end

    not_found do
      immediately_send_errors 404
    end
  end
end
