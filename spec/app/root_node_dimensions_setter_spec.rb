require "element"
require "root_node_dimensions_setter"
require "support/shared_examples/visitor"
require "text"

RSpec.describe RootNodeDimensionsSetter do
  subject(:visitor) {
    RootNodeDimensionsSetter.new(
      viewport_width: viewport_width,
      viewport_height: viewport_height,
    )
  }
  let(:viewport_width) { 640 }
  let(:viewport_height) { 480 }

  it_behaves_like "a visitor"

  let(:root) { Element.new(children: [first_child]) }
  let(:first_child) { Element.new }

  describe "the returned tree" do
    let(:returned_root) { visitor.call(root) }
    let(:returned_first_child) { returned_root.children.first }

    it "returns a new tree" do
      expect(returned_root).not_to eq(root)
    end

    it "sets the returned root node's dimensions to viewport's" do
      expect(returned_root.width).to eq(viewport_width)
      expect(returned_root.height).to eq(viewport_height)
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
