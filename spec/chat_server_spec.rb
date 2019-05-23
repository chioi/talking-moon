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
    ChatServer::App
  end

  describe 'for non existent routes' do
    before(:all) do
      env 'CONTENT_TYPE', ENV['ACCEPTED_CONTENT_TYPE']
      post "#{ENV['API_URL']}/we-will-never-have-this", @valid_message.to_json
      @not_found_error = JSONAPI::ResponseBuilder.build 404
    end

    context 'when a request is made' do
      it "the response has the 'not found' (404) status code" do
        expect(last_response).to be_not_found
      end

      it 'the response has an errors field' do
        expect(last_response.body).to eq(@not_found_error.to_json)
      end
    end
  end

  describe 'the /messages route' do
    before(:all) do
      @valid_message = Message.new('Hello Server!', 'xc434k')
    end

    context 'when a request with invalid type is posted' do
      before(:all) do
        env 'CONTENT_TYPE', 'application/json'
        post "#{ENV['API_URL']}/messages", @valid_message.to_json
        @unsupported_media_type_error = JSONAPI::ResponseBuilder.build 415
      end

      it "the response has the 'unsupported media type' (415) status code" do
        expect(last_response).to be_unsupported_media_type
      end

      it 'the response has an errors field' do
        expect(last_response.body).to eq(@unsupported_media_type_error.to_json)
      end
    end

    context 'when a valid message is posted' do
      before(:all) do
        env 'CONTENT_TYPE', ENV['ACCEPTED_CONTENT_TYPE']
        post "#{ENV['API_URL']}/messages", @valid_message.to_json
      end

      context 'when the message can be persisted' do
        it "the response has the 'no content' (204) status code" do
          expect(last_response).to be_no_content
        end
      end
    end
  end
end
