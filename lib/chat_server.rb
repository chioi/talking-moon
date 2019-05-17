require 'sinatra'
require "sinatra/reloader" if development?

set :bind, '0.0.0.0'

get '/' do
  'Hello World!'
end
