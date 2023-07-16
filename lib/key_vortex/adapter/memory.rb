# frozen_string_literal: true

require "key_vortex"
require "key_vortex/adapter"

class KeyVortex
  class Adapter
    # An in-memory implementation of an adapter. While typically not
    # useful in production, it can provide a convenient implementation
    # for unit testing.
    class Memory < KeyVortex::Adapter
      # A pass-through to the constructor which is used by
      # {KeyVortex.vortex}.
      # @param items [Hash]
      # @param limitations [Array of KeyVortex::Limitation]
      # @return [KeyVortex::Adapter::Memory]
      def self.build(items: {}, limitations: [])
        new(items, limitations: limitations)
      end

      # Create a new instance of the in-memory adapter. By default, it
      # has no limitations, but since it's most likely testing an
      # adapter which is more restrictive, it accepts a list of
      # limitations to apply.
      # @param items [Hash] The seed values that should be considered already saved.
      # @param limitations [Array of KeyVortex::Limitation]
      def initialize(items, limitations: [])
        super()
        @items = items
        limitations.each { |limit| register_limitation(limit) }
      end

      # Save the record to the provided hash using {Record#key} as the
      # key.
      # @param record [Record]
      def save(record)
        @items[record.key] = record
      end

      # @param key [String]
      # @return [Record, nil] The record with {Record#key} set to key
      def find(key)
        @items[key]
      end

      # Remove the record with {Record#key} set to key
      def remove(key)
        @items.delete(key)
      end
    end
  end
end

KeyVortex.register(KeyVortex::Adapter::Memory)
