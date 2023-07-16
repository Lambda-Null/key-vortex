# frozen_string_literal: true

class KeyVortex
  # Adapters bridge the gap between the main logic of KeyVortex and
  # individual backends. When using a backend, it can have various
  # limitations on particular data types. KeyVortex will guarantee that
  # these limitations are more permissive then the Records used to
  # interact with it.
  #
  # To keep dependencies down, the subclasses you'll actually use will
  # be implemented in other gems, but an in memory adapter does ship
  # with this gem.  Here are some that are available:
  #
  # * {https://github.com/Lambda-Null/key_vortex-stashify Stashify}: File/blob storage
  #
  # == Building Adapters
  #
  # For an adapter to work with KeyVortex, it needs to inherit from
  # this class. In addition, it needs to override the following
  # methods:
  #
  # * save({KeyVortex::Record}) => Anything
  # * find(String) => {KeyVortex::Record}
  # * remove(String) => Anything
  #
  # There is {https://github.com/Lambda-Null/key_vortex-contract a separate gem},
  # which provides a set of shared examples enforcing the correct
  # behavior of those methods. PRs to include your gem in the list in
  # the previous section will be accepted if they conform to that
  # contract.
  class Adapter
    def initialize
      @limitations = {}
    end

    # Get the limitation for the type of a given field.
    # @param field [KeyVortex::Field]
    # @return [KeyVortex::Limitation]
    def limitation_for(field)
      @limitations[field.limitation.type]
    end

    # Apply the provided limitation to the adapter.
    # @param limitation [KeyVortex::Limitation]
    def register_limitation(limitation)
      @limitations[limitation.type] = limitation
    end

    # Provide the symbol used when using the factory method
    # {KeyVortex.vortex}.
    # @return [Symbol] A symbol representing this class
    def self.symbol
      name.split(":").last.downcase.to_sym
    end
  end
end
