require "support/shared_examples/visitor"
require "support/visitor_double"

RSpec.describe "visitor_double" do
  let(:visitor) { visitor_double }

  it_behaves_like "a visitor"
end
