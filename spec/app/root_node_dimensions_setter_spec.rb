require "element"
require "root_node_dimensions_setter"
require "support/shared_examples/visitor"
require "text"

RSpec.describe RootNodeDimensionsSetter do
  subject(:visitor) {
    RootNodeDimensionsSetter.new(
      viewport_width: viewport_width,
    )
  }
  let(:viewport_width) { 640 }

  it_behaves_like "a visitor"

  let(:root) { Element.new(children: [first_child]) }
  let(:first_child) { Element.new }

  describe "the returned tree" do
    let(:returned_root) { visitor.call(root) }
    let(:returned_first_child) { returned_root.children.first }

    it "returns a new tree" do
      expect(returned_root).not_to eq(root)
    end

    it "sets the returned root node's width to viewport's" do
      expect(returned_root.width).to eq(viewport_width)
    end

    it "don't set the root node's height because later layout will do that" do
      expect(returned_root.height).to be_nil
    end

    it "sets the returned root node's position to the left, top page edge" do
      expect(returned_root.x).to eq(0)
      expect(returned_root.y).to eq(0)
    end

    it "doesn't affect the rest of the tree" do
      expect(returned_first_child).to eq(first_child)
    end
  end
end
