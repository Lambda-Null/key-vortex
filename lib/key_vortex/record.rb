# frozen_string_literal: true

require "key_vortex"
require "key_vortex/constraint"
require "key_vortex/field"
require "key_vortex/limitation"

class KeyVortex
  # To represent a structured piece of information you want to save,
  # it has to be a subclass of KeyVortex::Record. There will always be
  # field named {#key}, which is at most 36 characters long, but keys
  # with any other name can also be added.
  #
  #  class ExampleRecord < KeyVortex::Record
  #    field :a, Integer, minimum: 10, maximum: 100
  #    field :b, String, length: 100
  #    field :c, Integer
  #  end
  #
  # See {field} for more details on how those directives are
  # structured. When you're ready to use the class, values can be
  # provided either in the constructor like this:
  #
  #  ExampleRecord.new(
  #    a: 15,
  #    b: "foo",
  #    c: 1000,
  #  )
  #
  # Or set after the object is created like this:
  #
  #  r = ExampleRecord.new
  #  r.a = 15
  #  r.b = "foo"
  #  r.c = 1000
  #
  # In either case, the values can be retrieved as attributes after
  # they're set:
  #
  #  r.a # 15
  #  r.b # "foo"
  #  r.c # 1000
  class Record
    class << self
      # @return [Array] All of the fields declared for this class.
      def fields
        field_hash.values
      end

      # Declares what values are tracked by this record.
      # When declaring a field, it follows this general format:
      #
      #   field :field_name, ClassName, constraint1: contraint1_value, constraint2: constraint2_value
      #
      # From a record's perspective any number of
      # {KeyVortex::Constraint constraints} are valid, including none
      # at all.
      # @return [Field] The created field
      def field(name, type, **constraints)
        field = KeyVortex::Field.new(name, type, **constraints)
        register_field(field)
        field
      end

      # Convert a json parse result into a record for this class. This
      # is what's called when this command is used:
      #
      #   JSON.parse(json, create_additions: true)
      #
      # See {#to_json} for an example of the JSON structure this
      # example expects.
      # @return [Record] Subclasses will return an instance of themselves
      def json_create(object)
        new(object["values"])
      end

      protected

      def register_field(field)
        field_hash[field.name] = field
        field.enable_json_additions
        define_getter(field)
        define_setter(field)
      end

      private

      def field_hash
        @field_hash ||= {}
      end

      def define_getter(field)
        define_method(field.name) { @values[field.name] }
      end

      def define_setter(field)
        define_method("#{field.name}=") do |val|
          raise KeyVortex::Error, "Invalid value #{val} for #{field.name}" unless field.accepts?(val)

          @values[field.name] = val
        end
      end

      def inherited(subclass)
        super
        fields.each do |field|
          subclass.register_field(field)
        end
      end
    end

    # @!attribute key
    #   The key used to save and retrieve this record. Every field has
    #   a key defined, it can be a String up to 36 characters long,
    #   which is enough to accomodate a GUID if that's what you want
    #   to use.
    #   @return [String]
    field :key, String, length: 36

    # A hash of all of the attributes, in which the keys are symbols.
    # @example
    #   {
    #     a: 15,
    #     b: "foo",
    #     c: 1000,
    #   }
    #
    # @return [Hash]
    attr_reader :values

    # Values can optionally be specified when the object is created.
    # @example
    #  ExampleRecord.new(
    #    a: 15,
    #    b: "foo",
    #    c: 1000,
    #  )
    def initialize(values = {})
      @values = {}
      values.each do |name, value|
        send("#{name}=", value)
      end
    end

    # Two records are equal if they are the same class and have the
    # same values.
    # @return [Boolean]
    def ==(other)
      self.class == other.class && values == other.values
    end

    # Converts the record into a JSON string appropriate for parsing
    # using the create_additions option. Here is an example of the
    # format that's produced.
    #
    #   {
    #     "json_class": "ExampleRecord",
    #     "values": {
    #       "key": "foo",
    #       "a": 15,
    #       "b": "bar",
    #       "c": 1000
    #     }
    #   }
    #
    # @return [String] JSON representation of the object
    def to_json(*args)
      {
        JSON.create_id => self.class.name,
        "values" => @values
      }.to_json(*args)
    end
  end
end
