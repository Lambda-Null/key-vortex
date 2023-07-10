# frozen_string_literal: true

require "key_vortex/contract"
require "key_vortex/adapter/memory"

RSpec.describe KeyVortex::Adapter::Memory do
  subject { KeyVortex::Adapter::Memory.new({}) }
  it_behaves_like "an adapter"
end
