# frozen_string_literal: true

require "key_vortex/constraint/minimum"

RSpec.describe KeyVortex::Constraint::Minimum do
  subject do
    described_class.new(100)
  end

  it "is within a smaller minimum" do
    expect(subject.within?(described_class.new(subject.value - 1))).to be_truthy
  end

  it "is within the same minimum" do
    expect(subject.within?(described_class.new(subject.value))).to be_truthy
  end

  it "is not within a larger length" do
    expect(subject.within?(described_class.new(subject.value + 1))).to be_falsey
  end
end
