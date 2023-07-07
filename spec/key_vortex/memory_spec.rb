# frozen_string_literal: true

require "contract"
require "key_vortex/memory"

RSpec.describe KeyVortex::Memory do
  subject { KeyVortex::Memory.new({}) }
  it_behaves_like "a key vortex"
end
