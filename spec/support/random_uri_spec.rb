require "support/random_uri"

RSpec.describe RandomUri do
  it "returns a valid URI string" do
    expect {
      URI(RandomUri.new.to_s)
    }.not_to raise_error
  end
end
