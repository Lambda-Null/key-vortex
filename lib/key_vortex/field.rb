# frozen_string_literal: true

require "key_vortex/constraint"
require "key_vortex/limitation"

class KeyVortex
  class Field
    attr_reader :name, :limitation

    def initialize(name, type, *constraints_array, **constraints_hash)
      @name = name
      @limitation = KeyVortex::Limitation.new(type)

      @limitation.add_constraint(*constraints_array)
      @limitation.add_constraint(*constraints_hash.map do |attribute, value|
        KeyVortex::Constraint.build(attribute, value)
      end)
    end

    def within?(adapter)
      limitation = adapter.limitation_for(self)
      !limitation || self.limitation.within?(limitation)
    end

    def accepts?(value)
      limitation.accepts?(value)
    end
  end
end
