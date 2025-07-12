require_relative "../lib/token"

describe Token do
  subject(:token) { described_class.new("red") }

  it "has a color" do
    expect(token.color).not_to be nil
  end
end
