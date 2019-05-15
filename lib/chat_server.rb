require 'sinatra'

class Error < StandardError; end

get '/' do
  'Hello World!'
end