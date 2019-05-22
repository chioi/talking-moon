# frozen_string_literal: true

ENV['APP_ENV'] = 'test'

require 'rspec'
require 'json'
require 'rack/test'
require_relative '../lib/jsonable.rb'

RSpec.describe JSONable do
  context 'when subclassed by a class with no instance variables,' do
    describe 'the `to_json` method,' do
      before(:all) do
        class Kitty < JSONable
        end

        @kitty = Kitty.new
      end

      it 'outputs an empty json.' do
        json_kitty = @kitty.to_json
        expect(json_kitty).to eq('{}')
      end
    end
  end

  context 'when subclassed by a class with `nil` instance variables,' do
    describe 'the `to_json` method,' do
      before(:all) do
        class Kitty < JSONable
          def initialize(name = nil)
            @name = name
          end
        end

        @kitty = Kitty.new
      end

      it 'outputs an empty json.' do
        json_kitty = @kitty.to_json
        expect(json_kitty).to eq('{}')
      end
    end
  end

  context 'when subclassed by a class with instance variables,' do
    describe 'the `to_json` method,' do
      before(:all) do
        class Puppy < JSONable
          def initialize(name)
            @name = name
          end
        end

        @puppy = Puppy.new 'Vera'
      end

      it 'outputs a json representation of the instance variables.' do
        json_puppy = @puppy.to_json
        expect(json_puppy).to eq('{"name":"Vera"}')
      end
    end
  end
end
