require "absolute_position_adder_upper"
require "box"
require "build_text"
require "element"
require "support/shared_examples/visitor"

RSpec.describe AbsolutePositionAdderUpper do
  subject(:visitor) { AbsolutePositionAdderUpper.new }

  it_behaves_like "a visitor"

  let(:root) { Element.new(children: [child], box: offset_from_edges) }
  let(:child) { Element.new(children: [grandchild], box: offset_from_edges) }
  let(:grandchild) {
    BuildText.new.call(
      box: offset_from_edges.clone_with(width: 100, height: 14),
      content: "A Hell on Earth",
    )
  }
  let(:texts_internal_row) { grandchild.rows.first }

  let(:offset_from_edges) { Box.new(x: 100, y: 100, width: 0, height: 0) }

  let(:returned_root) { visitor.call(root) }
  let(:returned_child) { returned_root.children.first }
  let(:returned_grandchild) { returned_child.children.first }
  let(:returned_internal_text_row) { returned_grandchild.rows.first }

  it "returns a new tree" do
    expect(returned_root).not_to eq(root)
  end

  describe "setting new positions for nodes" do
    it "doesn't affect the root node's position" do
      expect(returned_root.x).to eq(root.x)
      expect(returned_root.y).to eq(root.y)
    end

    it "adds up a node's or text row's x from its ancestors'" do
      expect(returned_child.x).to eq(root.x + child.x)
      expect(returned_grandchild.x).to eq(root.x + child.x + grandchild.x)
      expect(returned_internal_text_row.x).to eq(
        root.x + child.x + grandchild.x + texts_internal_row.x
      )
    end

    it "adds up a node's or text row's y from its ancestors'" do
      expect(returned_child.y).to eq(root.y + child.y)
      expect(returned_grandchild.y).to eq(root.y + child.y + grandchild.y)
      expect(returned_internal_text_row.y).to eq(
        root.y + child.y + grandchild.y + texts_internal_row.y
      )
    end
  end
end
