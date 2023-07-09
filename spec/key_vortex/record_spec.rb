# frozen_string_literal: true

require "key_vortex/record"

class RecordOne < KeyVortex::Record
  field :one, String
end

class RecordTwo < KeyVortex::Record
  field :two, String
end

RSpec.describe KeyVortex::Record do
  it "only has constraints for the specific record and its parent" do
    expect(RecordOne.fields.map(&:name)).to eq(%i[key one])
    expect(RecordTwo.fields.map(&:name)).to eq(%i[key two])
  end
end
