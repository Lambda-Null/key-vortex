# frozen_string_literal: true

require "key_vortex"
require "key_vortex/constraint"
require "key_vortex/field"
require "key_vortex/limitation"

class KeyVortex
  class Record
    def self.fields
      field_hash.values
    end

    def self.field_hash
      @field_hash ||= {}
    end

    def self.field(name, type, **constraints_hash)
      register_field(KeyVortex::Field.new(name, type, **constraints_hash))
    end

    def self.field_constraints(field)
      @field_hash[field]
    end

    def self.register_field(field)
      field_hash[field.name] = field
      define_getter(field)
      define_setter(field)
    end

    def self.define_getter(field)
      define_method(field.name) { @values[field.name] }
    end

    def self.define_setter(field)
      define_method("#{field.name}=") do |val|
        raise KeyVortex::Error, "Invalid value #{val} for #{field.name}" unless field.accepts?(val)

        @values[field.name] = val
      end
    end

    def self.inherited(subclass)
      super
      fields.each do |field|
        subclass.register_field(field)
      end
    end

    # Long enough to accomodate a GUID
    field :key, String, length: 36

    attr_reader :values

    def initialize(values = {})
      @values = {}
      values.each do |name, value|
        send("#{name}=", value)
      end
    end

    def ==(other)
      self.class == other.class && values == other.values
    end
  end
end
