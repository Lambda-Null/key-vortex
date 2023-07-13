# frozen_string_literal: true

require "key_vortex"
require "key_vortex/adapter"

class KeyVortex
  class Adapter
    class Memory < KeyVortex::Adapter
      def self.build(items: {}, limitations: [])
        new(items, limitations: limitations)
      end

      def initialize(items, limitations: [])
        super()
        @items = items
        limitations.each { |limit| register_limitation(limit) }
      end

      def save(record)
        @items[record.key] = record
      end

      def find(id)
        @items[id]
      end

      def remove(key)
        @items.delete(key)
      end
    end
  end
end

KeyVortex.register(KeyVortex::Adapter::Memory)
