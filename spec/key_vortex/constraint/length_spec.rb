# frozen_string_literal: true

require "key_vortex/constraint/length"

RSpec.describe KeyVortex::Constraint::Length do
  subject do
    described_class.new(100)
  end

  it "is within a larger length" do
    expect(subject.within?(described_class.new(subject.value + 1))).to be_truthy
  end

  it "is within the same length" do
    expect(subject.within?(described_class.new(subject.value))).to be_truthy
  end

  it "is not within a smaller length" do
    expect(subject.within?(described_class.new(subject.value - 1))).to be_falsey
  end
end
