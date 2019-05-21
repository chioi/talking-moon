# frozen_string_literal: true

ENV['APP_ENV'] = 'test'

require 'uri'
require 'chat_server'
require 'rspec'
require 'rack/test'
require_relative '../lib/message_store.rb'
require_relative '../lib/message_model.rb'

RSpec.describe 'Chat server API' do
  include Rack::Test::Methods

  def app
    ChatServer
  end

  describe 'the /messages route' do
    before(:all) do
      @valid_message = Message.new('Hello Server!', 'xc434k')
    end

    context 'when a request with invalid type is posted' do
      it "responds with the 'unsupported media type' (415) status code" do
        env 'CONTENT_TYPE', 'application/json'
        post "#{ENV['API_URL']}/messages", @valid_message.to_json
        expect(last_response).to be_unsupported_media_type
      end
    end

    context 'when a valid message is posted' do
      context 'when the message can be persisted' do
        it "responds with the 'no content' (204) status code" do
          env 'CONTENT_TYPE', 'application/vnd.api+json'
          post "#{ENV['API_URL']}/messages", @valid_message.to_json
          expect(last_response).to be_no_content
        end
      end
    end
  end
end
