# frozen_string_literal: true

require "key_vortex/constraint/base"

class KeyVortex
  module Constraint
    # Enforces that objects which respond to #length less than the
    # specified limit.
    class Length < KeyVortex::Constraint::Base
      # @return [Integer] The upper bound allowed when calling #length on a value
      attr_reader :limit

      # @param limit [Integer] The maximum allowed value
      def initialize(limit)
        super()
        @limit = limit
      end

      # @return [Symbol] :length
      def attribute
        :length
      end

      # @param constraint [Length]
      # @return [Boolean] True if limit <= constraint.limit
      def within?(constraint)
        super && limit <= constraint.limit
      end

      # @param value [Object] Must respond to #length
      # @return [Boolean] True if length <= limit
      def accepts?(value)
        value.length <= limit
      end
    end
  end
end
