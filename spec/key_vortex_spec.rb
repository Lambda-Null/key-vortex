# frozen_string_literal: true

require "key_vortex/adapter/memory"
require "key_vortex/constraint"
require "key_vortex/limitation"
require "key_vortex/record"

class BigStringRecord < KeyVortex::Record
  field :name, String, length: 1000
end

class BasicRecord < KeyVortex::Record
  field :a, String
end

RSpec.describe KeyVortex do
  it "has a version number" do
    expect(KeyVortex::VERSION).not_to be nil
  end

  it "refuses to work with a record beyond the adapters limitations" do
    expect do
      KeyVortex.new(
        KeyVortex::Adapter::Memory.new(
          {},
          limitations: [
            KeyVortex::Limitation.new(
              String,
              KeyVortex::Constraint.build(:length, 40)
            )
          ]
        ),
        BigStringRecord
      )
    end.to raise_exception(KeyVortex::Error)
  end

  it "saves, finds and deletes a record" do
    vortex = KeyVortex.vortex(:memory, BasicRecord)
    record = BasicRecord.new(key: "foo", a: "bar")
    vortex.save(record)
    expect(vortex.find(record.key)).to eq(record)
    vortex.remove(record.key)
    expect(vortex.find(record.key)).to be_nil
  end
end
