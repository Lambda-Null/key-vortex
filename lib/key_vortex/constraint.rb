# frozen_string_literal: true

require "key_vortex/constraint/base"
require "key_vortex/constraint/length"
require "key_vortex/constraint/maximum"
require "key_vortex/constraint/minimum"
require "key_vortex/constraint/regexp"

class KeyVortex
  # Constraints define a restriction on the values which can be used
  # for {KeyVortex::Record} and {KeyVortex::Adapter}. Although they
  # are somewhat varied, they do have some common properties.
  #
  # All constraints have some sort of attribute name and limit. In
  # most situations, instead of the constructor, this pair will be
  # used to specify the constraint. For example, you would typically
  # specify a length like this:
  #
  #  length: 10
  #
  # All constraints will inherit from
  # {KeyVortex::Constraint::Base}. Because of the common ancestor,
  # along with the need to have a single file loading all constraints,
  # {KeyVortex::Constraint} is a module instead of the base class to
  # avoid a circular dependency.
  #
  # All constraints can determine if a value is valid for them.
  #
  # Most constraints, when compared with other instances of
  # themselves, can be determined if ones limitations fit within the
  # others. More formally, given an instance x of a constraint, an
  # instance y of the same constraint fits within x if and only if for
  # all values v that are valid for y, v is also valid for x.
  module Constraint
    # Factory enabling the specification of constraints by attribute
    # names instead of constructors.
    # @param attribute [Symbol]
    # @param limit [Object]
    # @return [KeyVortex::Constraint::Base] Subclass specified by attribute
    # @raise [KeyVortex::Error] If the attribute is unknown
    def self.build(attribute, limit)
      case attribute
      when :length
        KeyVortex::Constraint::Length.new(limit)
      when :maximum
        KeyVortex::Constraint::Maximum.new(limit)
      when :minimum
        KeyVortex::Constraint::Minimum.new(limit)
      when :regexp
        KeyVortex::Constraint::Regexp.new(limit)
      else
        raise KeyVortex::Error, "Unexpected attribute: #{attribute}"
      end
    end
  end
end

#
# Adapters can also have constraints, though, and if a particular
# type is more constrained then the record KeyVortex will refuse to
# use that record. If you don't specify any constraints, for
# example, the adapter will throw an error unless it is also
# unconstrained on that type.
