# frozen_string_literal: true

require "key_vortex/constraint"

RSpec.describe KeyVortex::Constraint do
  it "is within a constraint for a different attribute" do
    expect(
      described_class.build(:length, 10)
        .within?(described_class.build(:maximum, 100))
    ).to be_truthy
  end

  it { expect(described_class.build(:length, 10)).to be_a(KeyVortex::Constraint::Length) }
  it { expect(described_class.build(:maximum, 10)).to be_a(KeyVortex::Constraint::Maximum) }
  it { expect(described_class.build(:minimum, 10)).to be_a(KeyVortex::Constraint::Minimum) }
end
