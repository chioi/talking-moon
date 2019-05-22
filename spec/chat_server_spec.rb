# frozen_string_literal: true

ENV['APP_ENV'] = 'test'

require 'uri'
require 'chat_server'
require 'rspec'
require 'rack/test'
require_relative '../lib/message_store.rb'
require_relative '../lib/message_model.rb'
require_relative '../lib/response_creator.rb'

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
      it "the response has the 'unsupported media type' (415) status code" do
        env 'CONTENT_TYPE', 'application/json'
        post "#{ENV['API_URL']}/messages", @valid_message.to_json
        expect(last_response).to be_unsupported_media_type
      end

      it 'the response has an errors field' do
        env 'CONTENT_TYPE', 'application/json'
        post "#{ENV['API_URL']}/messages", @valid_message.to_json
        parsed_body = JSON.parse last_response.body
        expect(parsed_body).to eq('errors' => [])
      end
    end

    context 'when a valid message is posted' do
      context 'when the message can be persisted' do
        it "the response has the 'no content' (204) status code" do
          env 'CONTENT_TYPE', 'application/vnd.api+json'
          post "#{ENV['API_URL']}/messages", @valid_message.to_json
          expect(last_response).to be_no_content
        end
      end
    end
  end
end
