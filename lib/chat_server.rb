# frozen_string_literal: true

require 'dotenv'
require 'sinatra'
require 'rack/bodyparser'
require_relative 'message_store'
require_relative 'response_creator'

require 'sinatra/reloader' if development?
Dotenv.load(".env.#{ENV['APP_ENV']}")
ACCEPTED_CONTENT_TYPE = ENV['ACCEPTED_CONTENT_TYPE']

class ChatServer < Sinatra::Application
  def initialize
    @store = MessageStore.new({})
  end

  set :bind, '0.0.0.0'
  use Rack::BodyParser, parsers: {
    ACCEPTED_CONTENT_TYPE => proc { |data| JSON.parse data }
  }

  before do
    reject_invalid_request_content_type
    set_default_response_content_type
  end

  post "#{ENV['API_URL']}/messages" do
    message = Message.from_hash env['parsed_body']
    @store.save message
    status 204
  end

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
