# frozen_string_literal: true

require 'dotenv'
require 'sinatra'
require 'rack/bodyparser'
require_relative 'message_store'

require 'sinatra/reloader' if development?
Dotenv.load(".env.#{ENV['APP_ENV']}")

store = MessageStore.new({})

set :bind, '0.0.0.0'

class ChatServer < Sinatra::Application
  set :bind, '0.0.0.0'
  use Rack::BodyParser, parsers: {
    'application/vnd.api+json' => proc { |data| JSON.parse data }
  }

  post "#{ENV['API_URL']}/messages" do
    puts env['parsed_body']
    message = Message.new(parsed_body.body, parsed_body.sender)
    store.save message
    status 204
  end
end
