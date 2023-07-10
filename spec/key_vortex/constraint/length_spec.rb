# frozen_string_literal: true

require "key_vortex/constraint/length"

RSpec.describe KeyVortex::Constraint::Length do
  subject do
    described_class.new(5)
  end

  describe "#within?" do
    it "allows a larger length" do
      expect(subject.within?(described_class.new(subject.limit + 1))).to be_truthy
    end

    it "allows the same length" do
      expect(subject.within?(described_class.new(subject.limit))).to be_truthy
    end

    it "rejects a smaller length" do
      expect(subject.within?(described_class.new(subject.limit - 1))).to be_falsey
    end
  end

  describe "#accepts?" do
    it "allows a smaller string" do
      expect(subject.accepts?("foo")).to be_truthy
    end

    it "allows an equal length string" do
      expect(subject.accepts?("fooba")).to be_truthy
    end

    it "rejects a larger string" do
      expect(subject.accepts?("foobar")).to be_falsey
    end
  end
end
