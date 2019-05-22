# frozen_string_literal: true

require 'jsonable'

class Message < JSONable
  def initialize(body = {}, sender = '')
    @body = body
    @sender = sender
  end

  def self.from_hash(config)
    Message.new config['body'], config['sender']
  end
end
