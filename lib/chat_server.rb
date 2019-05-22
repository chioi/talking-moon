# frozen_string_literal: true

require 'dotenv'
require 'sinatra'
require 'rack/bodyparser'
require_relative 'message_store'
require_relative 'response_creator'

require 'sinatra/reloader' if development?
Dotenv.load(".env.#{ENV['APP_ENV']}")
ACCEPTED_CONTENT_TYPE = 'application/vnd.api+json'

class ChatServer < Sinatra::Application
  def initialize
    @store = MessageStore.new({})
  end

  set :bind, '0.0.0.0'
  use Rack::BodyParser, parsers: {
    'application/vnd.api+json' => proc { |data| JSON.parse data }
  }

  before do
    content_type ACCEPTED_CONTENT_TYPE
    halt [415, {}, ResponseCreator.createWithErrors([]).to_json] unless request.content_type == 'application/vnd.api+json'
  end

  post "#{ENV['API_URL']}/messages" do
    message = Message.new(read_request_body('body'), read_request_body('sender'))
    @store.save message
    status 204
  end

  def read_request_body(attribute)
    env['parsed_body'][attribute]
  end
end
