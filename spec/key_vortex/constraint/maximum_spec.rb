# frozen_string_literal: true

require "key_vortex/constraint/maximum"

RSpec.describe KeyVortex::Constraint::Maximum do
  subject do
    described_class.new(100)
  end

  it "is within a larger maximum" do
    expect(subject.within?(described_class.new(subject.value + 1))).to be_truthy
  end

  it "is within the same maximum" do
    expect(subject.within?(described_class.new(subject.value))).to be_truthy
  end

  it "is not within a smaller maximum" do
    expect(subject.within?(described_class.new(subject.value - 1))).to be_falsey
  end
end
