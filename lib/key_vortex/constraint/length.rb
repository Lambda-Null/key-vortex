# frozen_string_literal: true

require "key_vortex/constraint/base"

class KeyVortex
  class Constraint
    class Length < KeyVortex::Constraint::Base
      attr_reader :limit

      def initialize(limit)
        super()
        @limit = limit
      end

      def attribute
        :length
      end

      def within?(constraint)
        super && limit <= constraint.limit
      end

      def accepts?(value)
        value.length <= limit
      end
    end
  end
end
