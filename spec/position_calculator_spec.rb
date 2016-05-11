require "box"
require "position_calculator"
require "support/shared_examples/visitor"

RSpec.describe PositionCalculator do
  subject(:visitor) { PositionCalculator.new }

  it_behaves_like "a visitor"

  describe "custom depth-first tree traversal" do
    let(:root) { Element.new(children: children) }
    let(:children) { [Element.new(children: grandchildren), Element.new] }
    let(:grandchildren) { [Text.new(content: "ABC"), Element.new] }

    let(:all_nodes) { [root] + children + grandchildren }

    before do
      all_nodes.each do |node|
        allow(node).to receive(:accept_visit).and_call_original
      end

      visitor.visit(root)
    end

    it "visits all nodes once in depth-first order" do
      expect(root).to have_received(:accept_visit).ordered
      expect(children.first).to have_received(:accept_visit).ordered
      expect(grandchildren.first).to have_received(:accept_visit).ordered
      expect(grandchildren.last).to have_received(:accept_visit).ordered
      expect(children.last).to have_received(:accept_visit).ordered
    end
  end

  describe "the returned tree" do
    let(:root) { Element.new(children: [first_child, last_child]) }
    let(:first_child) {
      Element.new(
        box: a_box_of_height,
        children: [first_grandchild, last_grandchild],
      )
    }
    let(:first_grandchild) { Text.new(box: a_box_of_height, content: "ABC") }
    let(:last_grandchild) { Element.new }
    let(:last_child) { Element.new }

    let(:a_box_of_height) { Box.new(0, 0, 0, 11) }

    let(:returned_root) { visitor.visit(root) }
    let(:returned_first_child) { returned_root.children.first }
    let(:returned_first_grandchild) { returned_first_child.children.first }
    let(:returned_last_grandchild) { returned_first_child.children.last }
    let(:returned_last_child) { returned_root.children.last }

    it "returns a new tree" do
      expect(returned_root).not_to eq(root)
    end

    it "adjusts top positions for at least some of the new tree" do
      number_of_nodes_with_adjusted_y_positions = [
        [root,             returned_root],
        [first_child,      returned_first_child],
        [first_grandchild, returned_first_grandchild],
        [last_grandchild,  returned_last_grandchild],
        [last_child,       returned_last_child],
      ]
      .map { |original_node, new_node|
        new_node.box.y != original_node.box.y
      }
      .select { |x| x }
      .size

      expect(number_of_nodes_with_adjusted_y_positions).to be > 1
    end

    it "positions nodes below their preceding siblings" do
      expect(returned_last_grandchild.box.y).to be >=
        returned_first_grandchild.box.y + returned_first_grandchild.box.height

      expect(returned_last_child.box.y).to be >=
        returned_first_child.box.y + returned_first_child.box.height
    end

    it "doesn't position nodes above their parents" do
      expect(returned_first_child.box.y).to be >= returned_root.box.y
      expect(returned_last_child.box.y).to be >= returned_root.box.y

      expect(returned_first_grandchild.box.y).to be >= returned_first_child.box.y
      expect(returned_last_grandchild.box.y).to be >= returned_first_child.box.y
    end
  end
end