# frozen_string_literal: true

require_relative "key_vortex/version"

class KeyVortex
  class Error < StandardError; end

  def initialize(adapter, record_class)
    @adapter = adapter
    @record_class = record_class

    record_class.fields.each do |field|
      next unless field.prohibited_by?(adapter)

      raise KeyVortex::Error,
            "#{adapter.class} can only handle field #{field.name} with these limitations:\n" +
            adapter.limitation_for(field).to_s +
            "\n\nThe following record violates these limitations:\n#{field.limitation}"
    end
  end

  def save(record)
    @adapter.save(record)
  end

  def find(id)
    @adapter.find(id)
  end
end
