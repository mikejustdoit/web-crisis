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

  context "with Element root node" do
    let(:root) { Element.new(children: children) }
    let(:children) { [first_child, last_child] }
    let(:first_child) { Element.new(children: grandchildren) }
    let(:last_child) { Element.new }
    let(:grandchildren) { [first_grandchild, last_grandchild] }
    let(:first_grandchild) { Text.new(content: "ABC") }
    let(:last_grandchild) { Element.new }

    describe "the returned tree" do
      let(:returned_root) { visitor.call(root) }
      let(:returned_first_child) { returned_root.children.first }
      let(:returned_last_child) { returned_root.children.last }
      let(:returned_first_grandchild) { returned_first_child.children.first }
      let(:returned_last_grandchild) { returned_first_child.children.last }

      it "returns a new tree" do
        expect(returned_root).not_to eq(root)
      end

      it "sets the returned root node's dimensions to viewport's" do
        expect(returned_root.width).to eq(viewport_width)
        expect(returned_root.height).to eq(viewport_height)
      end

      it "sets the returned root node's position to the left, top viewport edge" do
        expect(returned_root.x).to eq(0)
        expect(returned_root.y).to eq(0)
      end

      it "doesn't affect the rest of the tree" do
        expect(returned_first_child).to eq(first_child)
        expect(returned_last_child).to eq(last_child)
        expect(returned_first_grandchild).to eq(first_grandchild)
        expect(returned_last_grandchild).to eq(last_grandchild)
      end
    end
  end

  context "with Text root node" do
    let(:root) { Text.new(content: "ABC") }

    describe "the returned tree" do
      let(:returned_node) { visitor.call(root) }

      it "returns the 'tree' unchanged" do
        expect(returned_node).to eq(root)
      end

      it "doesn't bother changing the root node's dimensions or position" do
        expect(returned_node.x).to eq(root.x)
        expect(returned_node.y).to eq(root.y)
        expect(returned_node.width).to eq(root.width)
        expect(returned_node.height).to eq(root.height)
      end
    end
  end
end
