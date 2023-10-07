# frozen_string_literal: true

require "key_vortex/constraint/regexp"

RSpec.describe KeyVortex::Constraint::Regexp do
  subject do
    described_class.new(/foo/)
  end

  # General bounds aren't possible given regexp flexibility
  describe "#within?" do
    it { expect(subject.within?(described_class.new(/f/))).to be_truthy }
    it { expect(subject.within?(described_class.new(/foobar/))).to be_truthy }
  end

  describe "#accepts?" do
    it "allows an exact match" do
      expect(subject.accepts?("foo")).to be_truthy
    end

    it "allows when within a string" do
      expect(subject.accepts?("foobar")).to be_truthy
    end

    it "rejects when not a full match" do
      expect(subject.accepts?("fo")).to be_falsey
    end
  end
end
