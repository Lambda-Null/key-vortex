# frozen_string_literal: true

require_relative "key_vortex/version"

# Defines the API you'll interact with when using this gem. Much of
# the functionality is delegated to other classes.
class KeyVortex
  # General purpose error used when issues arise within this gem.
  class Error < StandardError; end

  # Register an adapter class so that {.vortex} knows about it.
  # @param adapter_class [Class]
  def self.register(adapter_class)
    @adapter_registry ||= {}
    @adapter_registry[adapter_class.symbol] = adapter_class
  end

  # Creates an instance of {KeyVortex} with an appropriate
  # {Adapter}. An adapter class must have been associated with the
  # adapter_symbol by calling {.register}, this should have been done
  # by the file which defined that class. So, when you require
  # "key_vortex/adapter/memory" the :memory symbol will be defined for
  # use here.
  # @param adapter_symbol [Symbol]
  # @param record_class [Class] The class must inherit from {Record}
  # @param options [Hash] Options that will be passed through to .build on the adapter
  # @return [KeyVortex]
  def self.vortex(adapter_symbol, record_class, **options)
    new(
      @adapter_registry[adapter_symbol].build(**options),
      record_class
    )
  end

  # @return [Adapter]
  attr_reader :adapter
  # @return [Class] Subclass of {Record}
  attr_reader :record_class

  # While you are able to create the object directly, it's easier to
  # do so through {.vortex}.
  # @param adapter [Adapter] The backend that will be used to save and retrieve records
  # @param record_class [Class] The subclass of {Record} which will be saved and retreived
  # @raise [Error] If the constraints of the record_class do not fit within the constraints of the adapter
  def initialize(adapter, record_class)
    @adapter = adapter
    @record_class = record_class

    record_class.fields.each do |field|
      next if field.within?(adapter)

      raise KeyVortex::Error,
            "#{adapter.class} can only handle field #{field.name} with these limitations:\n" +
            adapter.limitation_for(field).to_s +
            "\n\nThe following record violates these limitations:\n#{field.limitation}"
    end
  end

  # Add the record to the {#adapter}. Once this is done, {#find} will
  # return this record when passed the {Record#key}.
  # @param record [Record] Must match {#record_class}
  def save(record)
    @adapter.save(record)
  end

  # Retrieve a record that has had {#save} called on it.
  # @param key [String]
  # @return [Record] The {Record} with {Record#key} set to key
  # @return [nil] if no record is found
  def find(key)
    @adapter.find(key)
  end

  # Remove the {Record} with {Record#key} set to key from the
  # {#adapter}.
  # @param key [String]
  def remove(key)
    @adapter.remove(key)
  end
end
