# frozen_string_literal: true

class KeyVortex
  class Memory
    def initialize(items)
      @items = items
    end

    def set(key, item)
      @items[key] = item
    end

    def get(key)
      @items[key]
    end

    def remove(key)
      @items.delete(key)
    end
  end
end
