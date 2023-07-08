# frozen_string_literal: true

class KeyVortex
  class Adapter
    class Memory < KeyVortex::Adapter
      def initialize(items)
        super()
        @items = items
      end

      def save(record)
        @items[record.id] = record
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
