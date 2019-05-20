# frozen_string_literal: true

require 'dotenv'
require 'sinatra'
require_relative 'message_store'

require 'sinatra/reloader' if development?
Dotenv.load(".env.#{ENV['APP_ENV']}")

store = MessageStore.new({})

set :bind, '0.0.0.0'

puts ENV['API_URL']

get "#{ENV['API_URL']}/:message" do |message|
  store.save message
  'Thanks!'
end

get ENV['API_URL'] do
  'Hello World!'
end
