# frozen_string_literal: true

require "key_vortex/constraint/base"

class KeyVortex
  module Constraint
    # Enforces that strings match the specified pattern. Because
    # regular expressions are too complicated to establish clean
    # bounds, it will not be considered when narrowing based on
    # adapter constraints.
    class Regexp < KeyVortex::Constraint::Base
      # @return [Regexp] The regexp the value must match
      attr_reader :pattern

      # @param pattern [Regexp] The regexp the value must match
      def initialize(pattern)
        super()
        @pattern = pattern
      end

      # @return [Symbol] :regexp
      def attribute
        :regexp
      end

      # @param [any]
      # @return [true] Regular expressions are too flexible, they cannot be compared
      def within?(_)
        true
      end

      # @param value [String]
      # @return [Boolean] True if pattern =~ value
      def accepts?(value)
        pattern =~ value
      end
    end
  end
end
