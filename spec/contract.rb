# frozen_string_literal: true

require "key_vortex/record"
require "securerandom"

class SampleRecord < KeyVortex::Record
  field :sample, String, maximum: 10
end

RSpec.shared_context "an adapter" do
  let(:store) do
    KeyVortex.new(
      subject,
      SampleRecord
    )
  end

  let(:record) do
    SampleRecord.new(
      id: SecureRandom.uuid,
      string: "foo"
    )
  end

  it "stores and removes a string" do
    store.save(record)
    expect(store.find(record.id)).to eq(record)
    subject.remove(record.id)
    expect(store.find(record.id)).to be_nil
  end
end
