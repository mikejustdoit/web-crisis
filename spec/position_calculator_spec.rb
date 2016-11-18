require "box"
require "position_calculator"
require "support/shared_examples/visitor"

RSpec.describe PositionCalculator do
  subject(:visitor) { PositionCalculator.new }

  it_behaves_like "a visitor"

  describe "the returned tree" do
    let(:root) { Element.new(children: [first_child, last_child]) }
    let(:first_child) {
      Element.new(
        box: a_box_of_height,
        children: [first_grandchild],
      )
    }
    let(:first_grandchild) { Text.new(box: a_box_of_height, content: "ABC") }
    let(:last_child) {
      Element.new(
        children: [last_grandchild],
      )
    }
    let(:last_grandchild) { Element.new }

    let(:a_box_of_height) { Box.new(x: 0, y: 0, width: 0, height: 11) }

    let(:returned_root) { visitor.call(root) }
    let(:returned_first_child) { returned_root.children.first }
    let(:returned_first_grandchild) { returned_first_child.children.first }
    let(:returned_last_child) { returned_root.children.last }
    let(:returned_last_grandchild) { returned_last_child.children.first }

    it "returns a new tree" do
      expect(returned_root).not_to eq(root)
    end

    it "adjusts top positions for at least some of the new tree" do
      number_of_nodes_with_adjusted_y_positions = [
        [root,             returned_root],
        [first_child,      returned_first_child],
        [first_grandchild, returned_first_grandchild],
        [last_child,       returned_last_child],
        [last_grandchild,  returned_last_grandchild],
      ]
      .map { |original_node, new_node|
        new_node.y != original_node.y
      }
      .select { |x| x }
      .size

      expect(number_of_nodes_with_adjusted_y_positions).to be > 1
    end

    it "positions nodes below their preceding siblings" do
      expect(returned_last_child.y).to be >= returned_first_child.bottom
    end

    it "doesn't position nodes above their parents" do
      expect(returned_first_child.y).to be >= returned_root.y
      expect(returned_last_child.y).to be >= returned_root.y

      expect(returned_first_grandchild.y).to be >= returned_first_child.y
      expect(returned_last_grandchild.y).to be >= returned_last_child.y
    end
  end
end
