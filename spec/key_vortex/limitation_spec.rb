# frozen_string_literal: true

require "key_vortex/constraint"
require "key_vortex/limitation"

RSpec.describe KeyVortex::Limitation do
  subject do
    KeyVortex::Limitation.new(
      String,
      KeyVortex::Constraint.build(:length, 5)
    )
  end

  it "throws an error when a non-constraint is provided to the constructor" do
    expect { KeyVortex::Limitation.new(String, 1) }
      .to raise_error(KeyVortex::Error)
  end

  it "accepts the described limitation" do
    expect(subject.accepts?("foo")).to be_truthy
  end

  it "rejects a different type" do
    expect(subject.accepts?(5)).to be_falsey
  end

  it "rejects a violated constraint" do
    expect(subject.accepts?("foobar")).to be_falsey
  end
end
