# frozen_string_literal: true

require "key_vortex/constraint/minimum"

RSpec.describe KeyVortex::Constraint::Minimum do
  subject do
    described_class.new(100)
  end

  describe "#within?" do
    it "is within a smaller minimum" do
      expect(subject.within?(described_class.new(subject.limit - 1))).to be_truthy
    end

    it "is within the same minimum" do
      expect(subject.within?(described_class.new(subject.limit))).to be_truthy
    end

    it "is not within a larger length" do
      expect(subject.within?(described_class.new(subject.limit + 1))).to be_falsey
    end
  end

  describe "#accepts?" do
    it "rejects a smaller value" do
      expect(subject.accepts?(99)).to be_falsey
    end

    it "allows an equal value" do
      expect(subject.accepts?(100)).to be_truthy
    end

    it "allows a larger value" do
      expect(subject.accepts?(101)).to be_truthy
    end
  end
end
