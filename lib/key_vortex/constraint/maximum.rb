# frozen_string_literal: true

require "key_vortex/constraint/base"

class KeyVortex
  module Constraint
    # Enforces that objects which respond to #<= are less than the
    # defined limit.
    class Maximum < KeyVortex::Constraint::Base
      # @return [Integer] The maximum allowed value
      attr_reader :limit

      # @param limit [Integer] The maximum allowed value
      def initialize(limit)
        super()
        @limit = limit
      end

      # @return [Symbol] :maximum
      def attribute
        :maximum
      end

      # @param constraint [Maximum]
      # @return [Boolean] True if limit <= constraint.limit
      def within?(constraint)
        super && limit <= constraint.limit
      end

      # @param value [Object] Must respond to #<=
      # @return [Boolean] True if value <= limit
      def accepts?(value)
        value <= limit
      end
    end
  end
end
