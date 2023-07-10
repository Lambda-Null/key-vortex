# frozen_string_literal: true

require "key_vortex/constraint/maximum"

RSpec.describe KeyVortex::Constraint::Maximum do
  subject do
    described_class.new(100)
  end

  describe "#within?" do
    it "is within a larger maximum" do
      expect(subject.within?(described_class.new(subject.limit + 1))).to be_truthy
    end

    it "is within the same maximum" do
      expect(subject.within?(described_class.new(subject.limit))).to be_truthy
    end

    it "is not within a smaller maximum" do
      expect(subject.within?(described_class.new(subject.limit - 1))).to be_falsey
    end
  end

  describe "#accepts?" do
    it "allows a smaller value" do
      expect(subject.accepts?(99)).to be_truthy
    end

    it "allows an equal value" do
      expect(subject.accepts?(100)).to be_truthy
    end

    it "rejects a larger value" do
      expect(subject.accepts?(101)).to be_falsey
    end
  end
end
