require "absolute_position_adder_upper"
require "box"
require "element"
require "support/shared_examples/visitor"
require "text"

RSpec.describe AbsolutePositionAdderUpper do
  subject(:visitor) { AbsolutePositionAdderUpper.new }

  it_behaves_like "a visitor"

  describe "the returned tree" do
    let(:root) { Element.new(children: [child], box: offset_from_edges) }
    let(:child) { Element.new(children: [grandchild], box: offset_from_edges) }
    let(:grandchild) { Text.new(content: "ABC", box: offset_from_edges) }

    let(:offset_from_edges) { Box.new(x: 100, y: 100, width: 0, height: 0) }

    let(:returned_root) { visitor.call(root) }
    let(:returned_child) { returned_root.children.first }
    let(:returned_grandchild) { returned_child.children.first }

    it "returns a new tree" do
      expect(returned_root).not_to eq(root)
    end

    it "doesn't affect the root node's position" do
      expect(returned_root.x).to eq(root.x)
      expect(returned_root.y).to eq(root.y)
    end

    it "adds up a node's x from its ancestors'" do
      expect(returned_child.x).to eq(root.x + child.x)
      expect(returned_grandchild.x).to eq(root.x + child.x + grandchild.x)
    end

    it "adds up a node's y from its ancestors'" do
      expect(returned_child.y).to eq(root.y + child.y)
      expect(returned_grandchild.y).to eq(root.y + child.y + grandchild.y)
    end
  end
end
