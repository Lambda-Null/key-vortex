# frozen_string_literal: true

require "key_vortex/constraint/base"

class KeyVortex
  class Constraint
    class Minimum < KeyVortex::Constraint::Base
      attr_reader :limit

      def initialize(limit)
        super()
        @limit = limit
      end

      def attribute
        :maximum
      end

      def within?(constraint)
        super && limit >= constraint.limit
      end

      def accepts?(value)
        value >= limit
      end
    end
  end
end
