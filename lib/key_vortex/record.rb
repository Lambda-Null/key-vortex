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

    def self.register_field(field)
      field_hash[field.name] = field
    end

    def self.inherited(subclass)
      super
      fields.each do |field|
        subclass.register_field(field)
      end
    end

    # Long enough to accomodate a GUID
    field :key, String, length: 36

    def initialize(fields)
      @field_hash = fields
    end

    def respond_to_missing?(method, *args)
      args.empty? && self.class.field_constraints(method)
    end

    def method_missing(method, *_args)
      @field_hash[method]
    end

    def self.field_constraints(field)
      @field_hash[field]
    end
  end
end
