require "root_node_dimensions_setter"
require "node"
require "text_node"

RSpec.describe RootNodeDimensionsSetter do
  let(:root) { Node.new(children: children) }
  let(:children) { [Node.new(children: grandchildren), Node.new] }
  let(:grandchildren) { [TextNode.new(content: "ABC"), Node.new] }

  let(:layout_visitor) {
    RootNodeDimensionsSetter.new(viewport_width, viewport_height)
  }
  let(:viewport_width) { 640 }
  let(:viewport_height) { 480 }

  describe "not traversing the tree" do
    before do
      allow(root).to receive(:layout).and_call_original

      layout_visitor.visit(root)
    end

    it "sends #layout to root node only" do
      expect(root).to have_received(:layout)
    end
  end

  describe "the returned tree" do
    let(:returned_node) { layout_visitor.visit(root) }

    it "returns a new tree" do
      expect(returned_node).not_to eq(root)
    end

    it "sets the returned root node's dimensions to viewport's" do
      expect(returned_node.box.width).to eq(viewport_width)
      expect(returned_node.box.height).to eq(viewport_height)
    end
  end
end
