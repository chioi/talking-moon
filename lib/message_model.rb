# frozen_string_literal: true

class Message
  def initialize(id, body, sender)
    @id = id
    @body = body
    @sender = sender
  end
end
