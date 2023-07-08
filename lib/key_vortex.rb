# frozen_string_literal: true

require_relative "key_vortex/version"

class KeyVortex
  class Error < StandardError; end

  def initialize(adapter, record_class)
    @adapter = adapter
    @record_class = record_class
  end

  def save(record)
    @adapter.save(record)
  end

  def find(id)
    @adapter.find(id)
  end
end
