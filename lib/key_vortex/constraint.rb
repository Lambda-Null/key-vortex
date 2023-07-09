# frozen_string_literal: true

require "key_vortex/constraint/base"
require "key_vortex/constraint/length"
require "key_vortex/constraint/maximum"
require "key_vortex/constraint/minimum"

class KeyVortex
  class Constraint
    def self.build(attribute, value)
      case attribute
      when :length
        KeyVortex::Constraint::Length.new(value)
      when :maximum
        KeyVortex::Constraint::Maximum.new(value)
      when :minimum
        KeyVortex::Constraint::Minimum.new(value)
      else
        raise KeyVortex::Error, "Unexpected attribute: #{attribute}"
      end
    end
  end
end
