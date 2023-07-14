# frozen_string_literal: true

require_relative "key_vortex/version"

class KeyVortex
  class Error < StandardError; end

  def self.register(adapter_class)
    @adapter_registry ||= {}
    @adapter_registry[adapter_class.symbol] = adapter_class
  end

  def self.vortex(adapter_symbol, record_class, **options)
    puts @adapter_registry
    new(
      @adapter_registry[adapter_symbol].build(**options),
      record_class
    )
  end

  attr_reader :adapter, :record_class

  def initialize(adapter, record_class)
    @adapter = adapter
    @record_class = record_class

    record_class.fields.each do |field|
      next if field.within?(adapter)

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
