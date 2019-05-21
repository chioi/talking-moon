# frozen_string_literal: true

class JSONable
  def initialize(instance)
    @instance_variables = {}
    @instance = instance
    populate_hash
  end

  def populate_hash
    @instance.instance_variables.each do |name|
      @instance_variables[name] = @instance.instance_variable_get name
    end
  end

  def to_json(*_args)
    @instance_variables.to_json
  end
end
