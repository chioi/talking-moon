# frozen_string_literal: true

require 'jsonable'

class Message
  def initialize(body, sender)
    @body = body
    @sender = sender
    @serializer = JSONable.new(self)
  end

  def to_json(*_args)
    @serializer.to_json
  end
end
