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

    def allows?(limitation)
      @constraints.all? do |constraint|
        limitation.accomodates?(constraint)
      end
    end

    def prohibits?(limitation)
      !allows?(limitation)
    end

    def accomodates?(constraint)
      @constraints.all? do |con|
        con.within?(constraint)
      end
    end

    def to_s
      "Limitation: #{@type}\n\t#{@constraints.join('\n\t')}"
    end
  end
end
