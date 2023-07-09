# frozen_string_literal: true

class KeyVortex
  class Constraint
    class Base
      def applies_to?(constraint)
        attribute == constraint.attribute
      end

      def within?(constraint)
        !applies_to?(constraint) || within_applicable?(constraint)
      end

      def to_s
        "#{attribute}: #{value}"
      end
    end
  end
end
