# frozen_string_literal: true

require 'securerandom'

class MessageStore
  def initialize(store)
    @store = store
  end

  def save(message)
    id = generateID
    @store[id] = message
  end

  def generateID
    SecureRandom.uuid
  end
end
