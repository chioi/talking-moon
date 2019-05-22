# frozen_string_literal: true

require 'json'

class JSONable
  def to_json(*_args)
    properties = {}

    instance_variables.each do |variable_name|
      instance_variable_value = instance_variable_get variable_name
      unless instance_variable_value.nil?
        properties[remove_at_character(variable_name)] = instance_variable_value
      end
    end

    properties.to_json
  end

  def remove_at_character(symbol)
    symbol.to_s.tr('@', '')
  end
end

class JSONAPIResponse < JSONable
end
