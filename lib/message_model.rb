# frozen_string_literal: true

require 'jsonable'

class Message < JSONable
  def initialize(body, sender)
    @body = body
    @sender = sender
  end
end
