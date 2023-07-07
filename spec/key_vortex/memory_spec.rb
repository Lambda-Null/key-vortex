# frozen_string_literal: true

require "key_vortex/memory"
require "key_vortex/record/string"

RSpec.describe KeyVortex::Memory do
  let(:store) { KeyVortex::Memory.new({}) }

  it "stores and removes a string" do
    string = KeyVortex::Record::String.new("bar")
    store.set("foo", string)
    expect(store.get("foo")).to eq(string)
    store.remove("foo")
  end
end
