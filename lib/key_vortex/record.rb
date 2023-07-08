# frozen_string_literal: true

class KeyVortex
  class Record
    def self.constraints
      @constraints ||= {}
    end

    def self.field(type, **constraints)
      self.constraints[type] = constraints
    end

    field :id

    def initialize(fields)
      @fields = fields
    end

    def respond_to_missing?(method, *args)
      args.empty? && self.class.field_constraints(method)
    end

    def method_missing(method, *_args)
      @fields[method]
    end

    def self.field_constraints(field)
      @fields[field]
    end
  end
end
