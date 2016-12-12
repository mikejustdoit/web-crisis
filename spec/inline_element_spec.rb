require "inline_element"
require "element"

RSpec.describe InlineElement do
  describe "cloning" do
    subject(:node) { InlineElement.new(Element.new(children: [])) }
    let(:returned_node) { node.clone_with({}) }

    it "returns a InlineElement" do
      expect(returned_node).to be_a(InlineElement)
    end
  end
end
