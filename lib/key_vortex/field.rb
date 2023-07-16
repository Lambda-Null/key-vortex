# frozen_string_literal: true

require "key_vortex/constraint"
require "key_vortex/limitation"

class KeyVortex
  # Defines a value that can be set on a {Record}. This generally
  # isn't built directly, you should use the {Record#field} directive
  # most of the time. This class ties a name to a {Limitation}, and
  # delegates most questions on to the latter.
  class Field
    # @return [Symbol] the name of the field
    attr_reader :name
    # @return [Limitation] the restrictions placed upon this field
    attr_reader :limitation

    # Creates an instance of this class and converts any
    # attribute/limit constraint pairs into {KeyVortex::Constraint}
    # objects.
    # @param name [Symbol] Name of the field
    # @param type [Class] Type used for limitation
    # @param constraints_array [Constraint::Base] Any constraints already constructed can be passed in as well
    # @param constraints_hash [Hash] key/value pairs that will be passed on to {Constraint#build}
    def initialize(name, type, *constraints_array, **constraints_hash)
      @name = name
      @limitation = KeyVortex::Limitation.new(type)

      @limitation.add_constraint(*constraints_array)
      @limitation.add_constraint(*constraints_hash.map do |attribute, value|
        KeyVortex::Constraint.build(attribute, value)
      end)
    end

    # @param adapter [Adapter]
    # @return [Boolean] true if the limitations for this field fit within the corresponding limitations for the adapter
    def within?(adapter)
      limitation = adapter.limitation_for(self)
      !limitation || self.limitation.within?(limitation)
    end

    # @param value [Object]
    # @return [Boolean] true if the value is valid for {#limitation}
    def accepts?(value)
      limitation.accepts?(value)
    end

    # Enable JSON additions for the class used for this field.
    def enable_json_additions
      @limitation.enable_json_additions
    end
  end
end
