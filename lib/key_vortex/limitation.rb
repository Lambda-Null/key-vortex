# frozen_string_literal: true

class KeyVortex
  class Limitation
    attr_reader :type, :constraints

    def initialize(type, *constraints)
      @type = type
      @constraints = constraints
    end

    def add_constraint(*constraints)
      constraints.each do |constraint|
        unless constraint.is_a?(KeyVortex::Constraint::Base)
          raise KeyVortex::Error,
                "Not a constraint: #{constraint.class}"
        end
      end

      @constraints += constraints
    end

    def encompasses?(limitation)
      @constraints.all? do |constraint|
        limitation.encompasses_constraint?(constraint)
      end
    end

    def encompasses_constraint?(constraint)
      !applicable_constraints(constraint).select do |con|
        con.within?(constraint)
      end.empty?
    end

    def within?(limitation)
      limitation.constraints.all? do |constraint|
        within_constraint?(constraint)
      end
    end

    def within_constraint?(constraint)
      !applicable_constraints(constraint).select do |con|
        con.within?(constraint)
      end.empty?
    end

    def applicable_constraints(constraint)
      @constraints.select do |con|
        con.applies_to?(constraint)
      end
    end

    def accepts?(value)
      value.is_a?(type) && @constraints.all? { |constraint| constraint.accepts?(value) }
    end

    def to_s
      "Limitation: #{@type}\n\t#{@constraints.join('\n\t')}"
    end
  end
end
