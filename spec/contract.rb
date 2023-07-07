# frozen_string_literal: true

require "key_vortex/record/string"

RSpec.shared_context "a key vortex" do
  it "stores and removes a string" do
    string = KeyVortex::Record::String.new("bar")
    subject.set("foo", string)
    expect(subject.get("foo")).to eq(string)
    subject.remove("foo")
  end
end
