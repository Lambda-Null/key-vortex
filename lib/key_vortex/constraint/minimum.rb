# frozen_string_literal: true

require "key_vortex/constraint/base"

class KeyVortex
  module Constraint
    # Enforces that objects which respond to #>= are greater than the
    # defined limit.
    class Minimum < KeyVortex::Constraint::Base
      # @return [Integer] The minimum allowed value
      attr_reader :limit

      # @param limit [Integer] The minimum allowed value
      def initialize(limit)
        super()
        @limit = limit
      end

      # @return [Symbol] :minimum
      def attribute
        :minimum
      end

      # @param constraint [Minimum]
      # @return [Boolean] True if limit >= constraint.limit
      def within?(constraint)
        super && limit >= constraint.limit
      end

      # @param value [Object] Must respond to #>=
      # @return [Boolean] True if value >= limit
      def accepts?(value)
        value >= limit
      end
    end
  end
end
