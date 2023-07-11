# frozen_string_literal: true

require "key_vortex/record"

class RecordOne < KeyVortex::Record
  field :one, String, length: 100
end

class AnotherRecordOne < KeyVortex::Record
  field :one, String, length: 100
end

class RecordTwo < KeyVortex::Record
  field :two, String
end

RSpec.describe KeyVortex::Record do
  let(:record) { RecordOne.new(one: "one") }

  context "field assignment" do
    it "only has constraints for the specific record and its parent" do
      expect(RecordOne.fields.map(&:name)).to eq(%i[key one])
      expect(RecordTwo.fields.map(&:name)).to eq(%i[key two])
    end

    it "assigns in constructor" do
      expect(record.one).to eq("one")
    end

    it "assigns through a setter" do
      record = RecordOne.new
      record.one = "one"
      expect(record.one).to eq("one")
    end

    it "refuses to assign an invalid field" do
      expect do
        record.two = 2
      end.to raise_error(NoMethodError)
    end

    it "rejects invalid field names provided in constructor" do
      expect do
        RecordOne.new(two: 2)
      end.to raise_error(NoMethodError)
    end

    it "rejects values that do not match the field" do
      expect do
        record.one = 100
      end.to raise_error(KeyVortex::Error)
    end

    it "rejects values that do not match the field provided in constructor" do
      expect do
        RecordOne.new(one: 100)
      end.to raise_error(KeyVortex::Error)
    end
  end

  describe "#eql?" do
    it { expect(RecordOne.new(one: "one")).to eq(RecordOne.new(one: "one")) }
    it { expect(RecordOne.new(one: "one")).to_not eq(AnotherRecordOne.new(one: "one")) }
    it { expect(RecordOne.new(one: "one")).to_not eq(RecordOne.new(one: "not one")) }
  end
end
