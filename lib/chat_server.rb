# frozen_string_literal: true

require 'dotenv'
require 'sinatra'
require 'rack/bodyparser'
require_relative 'message_store'
require 'pp'

require 'sinatra/reloader' if development?
Dotenv.load(".env.#{ENV['APP_ENV']}")

class ChatServer < Sinatra::Application
  def initialize
    @store = MessageStore.new({})
  end

  set :bind, '0.0.0.0'
  use Rack::BodyParser, parsers: {
    'application/vnd.api+json' => proc { |data| JSON.parse data }
  }

  post "#{ENV['API_URL']}/messages" do
    message = Message.new(read_request_body('body'), read_request_body('sender'))
    @store.save message
    status 204
  end

  def read_request_body(attribute)
    env['parsed_body'][attribute]
  end
end
