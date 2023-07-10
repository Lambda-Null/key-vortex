# frozen_string_literal: true

require "key_vortex/record"
require "securerandom"

class SampleRecord < KeyVortex::Record
  field :sample, String, length: 10
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
      key: SecureRandom.uuid,
      sample: "foo"
    )
  end

  it "stores and removes a string" do
    store.save(record)
    expect(store.find(record.key)).to eq(record)
    subject.remove(record.key)
    expect(store.find(record.key)).to be_nil
  end
end
