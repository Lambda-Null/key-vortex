# frozen_string_literal: true

require "key_vortex/adapter/memory"
require "key_vortex/field"
require "key_vortex/limitation"

RSpec.describe KeyVortex::Field do
  def adapter(limitations = [limitation])
    KeyVortex::Adapter::Memory.new({}, limitations: limitations)
  end

  let(:limitation) do
    KeyVortex::Limitation.new(String, KeyVortex::Constraint.build(:length, 5))
  end

  it "is prohibited by more restrictive constraints" do
    expect(KeyVortex::Field.new("foo", String, length: 10))
      .to be_prohibited_by(adapter)
  end

  it "is prohibited by unchecked constraints" do
    expect(KeyVortex::Field.new("foo", String))
      .to be_prohibited_by(adapter)
  end

  it "is not prohibited when adapter is also unchecked" do
    expect(KeyVortex::Field.new("foo", String))
      .to_not be_prohibited_by(adapter([]))
  end
end
