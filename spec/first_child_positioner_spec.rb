require "box"
require "element"
require "first_child_positioner"

RSpec.describe FirstChildPositioner do
  describe "positioning" do
    subject(:calculator) {
      FirstChildPositioner.new
    }
    let(:first_child) { Element.new }
    let(:parent_node) { Element.new(box: parent_node_box, children: [first_child]) }
    let(:parent_node_box) { Box.new(x: 100, y: 200, width: 300, height: 400) }

    let(:positioned_first_child) {
      calculator.call(first_child, parent_node: parent_node)
    }

    it "positions first child at top of its parent_node" do
      expect(positioned_first_child.y).to eq(parent_node.y)
    end
  end
end
