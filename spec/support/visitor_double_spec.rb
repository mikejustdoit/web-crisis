require "support/shared_examples/visitor"
require "support/visitor_double"

RSpec.describe "visitor_double" do
  subject(:visitor) { visitor_double }

  it_behaves_like "a visitor"

  describe "return values from visit methods" do
    let(:node) { double(:node) }

    it "passes element nodes straight through" do
      expect(visitor.visit_element(node)).to eq(node)
    end

    it "passes text nodes straight through" do
      expect(visitor.visit_text(node)).to eq(node)
    end
  end
end
