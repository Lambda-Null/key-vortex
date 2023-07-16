# frozen_string_literal: true

class KeyVortex
  # Represents a collection of {KeyVortex::Constraint constraints}
  # which apply to a given class. While these can be constructed
  # directly, the intended mechanism for applying these to a record is
  # through {KeyVortex::Record.field}.
  #
  # Two independent concepts which commonly use the same terminology
  # exist in this project. Consider the term "allows", is that
  # referring to what values are allowed or what constraints are
  # allowed? To help navigate these two concepts, the following
  # terminology convention is used throughout this codebase:
  # * Encompass/Within: Used when comparing limitations and constraints to each other
  # * Accepts/Rejects: Used when determining if a value is valid for constraints
  class Limitation
    # @return [Class] The class these constraints applies to.
    attr_reader :type

    # @return [Array] The constraints which apply to this class.
    attr_reader :constraints

    # @param type [Class]
    # @param constraints [KeyValue::Constraint]
    def initialize(type, *constraints)
      @type = type
      @constraints = []
      add_constraint(*constraints)
    end

    # Add constraints to this limitation. It is also possible to do
    # this through the constructor, but it is sometimes easier to do
    # it one at a time.
    # @param constraints [KeyVortex::Constraint::Base]
    def add_constraint(*constraints)
      constraints.each do |constraint|
        unless constraint.is_a?(KeyVortex::Constraint::Base)
          raise KeyVortex::Error,
                "Not a constraint: #{constraint.class}"
        end
      end

      @constraints += constraints
    end

    # Determine if any of the constraints in the provided limitation
    # exceed this limitation's constraints.
    # @param limitation [KeyVortex::Limitation]
    # @return [Boolean]
    def within?(limitation)
      limitation.constraints.all? do |constraint|
        within_constraint?(constraint)
      end
    end

    # Determine if a given value meets all of the constraints.
    # @param value [type]
    # @return [Boolean]
    def accepts?(value)
      value.is_a?(type) && @constraints.all? { |constraint| constraint.accepts?(value) }
    end

    # Ensure that JSON additions for {type} are loaded in case the
    # record needs to be serialized.
    def enable_json_additions
      path = JSON_ADDITIONS[@type.class.name]
      require path if path
    end

    # Return information about this limitation. The information will
    # be formatted as follows:
    #  Limitation: String
    #    minimum: 10
    #    maximum: 100
    # @return [String]
    def to_s
      "Limitation: #{@type}\n\t#{@constraints.join('\n\t')}"
    end

    private

    def within_constraint?(constraint)
      applicable_constraints(constraint).any? do |con|
        con.within?(constraint)
      end
    end

    def applicable_constraints(constraint)
      @constraints.select do |con|
        con.applies_to?(constraint)
      end
    end

    JSON_ADDITIONS = {
      BigDecimal: "json/add/bigdecimal",
      Complex: "json/add/complex",
      Date: "json/add/date",
      DateTime: "json/add/date_time",
      Exception: "json/add/exception",
      OpenStruct: "json/add/ostruct",
      Range: "json/add/range",
      Rational: "json/add/rational",
      Regexp: "json/add/regexp",
      Set: "json/add/set",
      Struct: "json/add/struct",
      Symbol: "json/add/symbol",
      Time: "json/add/time"
    }.freeze
  end
end
