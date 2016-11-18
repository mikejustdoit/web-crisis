require "support/shared_examples/visitor"
require "support/visitor_double"

RSpec.describe "visitor_double" do
  subject(:visitor) { visitor_double }

  it_behaves_like "a visitor"

  describe "return values from visit methods" do
    let(:element) { Element.new(box: box, children: []) }
    let(:text) { Text.new(box: box, content: "Just passing.") }
    let(:box) { Box.new(x: 0, y: 1, width: 2, height: 3) }

    it "passes element nodes straight through" do
      expect(visitor.call(element)).to eq(element)
    end

    it "passes text nodes straight through" do
      expect(visitor.call(text)).to eq(text)
    end
  end
end
