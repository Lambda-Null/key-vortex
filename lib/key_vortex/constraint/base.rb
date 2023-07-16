# frozen_string_literal: true

class KeyVortex
  module Constraint
    # Base class all other constraints inherit from. Does not define
    # all of the properties necessary for a constraint, and so is
    # inappropriate to be used directly.
    class Base
      # Comparing constraints is only valid when compared to other
      # instances of the same constraint. This helps other parts of
      # the system determine if this is true.
      # @param constraint [Base]
      # @return [Boolean]
      def applies_to?(constraint)
        attribute == constraint.attribute
      end

      # The individual constraint is responsible for making the
      # ultimate determination of if it is within another
      # constraint. What's common to all of them, though, is that they
      # must be the same class.
      def within?(constraint)
        constraint.instance_of?(self.class)
      end

      # A text description of the constraint. Assumes subclasses
      # define the methods attribute and limit.
      # @return [String]
      def to_s
        "#{attribute}: #{limit}"
      end
    end
  end
end
