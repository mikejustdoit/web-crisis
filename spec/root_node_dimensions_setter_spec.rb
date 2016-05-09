require "element"
require "root_node_dimensions_setter"
require "support/shared_examples/visitor"
require "text"

RSpec.describe RootNodeDimensionsSetter do
  let(:root) { Element.new(children: children) }
  let(:children) { [Element.new(children: grandchildren), Element.new] }
  let(:grandchildren) { [Text.new(content: "ABC"), Element.new] }

  subject(:visitor) {
    RootNodeDimensionsSetter.new(
      viewport_width: viewport_width,
      viewport_height: viewport_height,
    )
  }
  let(:viewport_width) { 640 }
  let(:viewport_height) { 480 }

  it_behaves_like "a visitor"

  describe "not traversing the tree" do
    before do
      allow(root).to receive(:accept_visit).and_call_original

      visitor.visit(root)
    end

    it "visits the root node only" do
      expect(root).to have_received(:accept_visit).with(visitor)
    end
  end

  describe "the returned tree" do
    let(:returned_node) { visitor.visit(root) }

    it "returns a new tree" do
      expect(returned_node).not_to eq(root)
    end

    it "sets the returned root node's dimensions to viewport's" do
      expect(returned_node.box.width).to eq(viewport_width)
      expect(returned_node.box.height).to eq(viewport_height)
    end
  end
end
