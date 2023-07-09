# frozen_string_literal: true

require "key_vortex/constraint/base"

class KeyVortex
  class Constraint
    class Length < KeyVortex::Constraint::Base
      attr_reader :value

      def initialize(value)
        super()
        @value = value
      end

      def attribute
        :length
      end

      def within_applicable?(constraint)
        value <= constraint.value
      end
    end
  end
end
