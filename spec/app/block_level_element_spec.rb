require "block_level_element"
require "element"

RSpec.describe BlockLevelElement do
  describe "cloning" do
    subject(:node) { BlockLevelElement.new(Element.new(children: [])) }
    let(:returned_node) { node.clone_with({}) }

    it "returns a BlockLevelElement" do
      expect(returned_node).to be_a(BlockLevelElement)
    end
  end
end
