# frozen_string_literal: true

class KeyVortex
  class Adapter
    def initialize
      @limitations = {}
    end

    def limitation_for(field)
      @limitations[field.limitation.type]
    end

    def register_limitation(limitation)
      @limitations[limitation.type] = limitation
    end
  end
end
