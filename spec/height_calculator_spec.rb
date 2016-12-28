require "box"
require "element"
require "height_calculator"
require "support/shared_examples/visitor"
require "text"

RSpec.describe HeightCalculator do
  subject(:visitor) { HeightCalculator.new }

  it_behaves_like "a visitor"

  it_behaves_like "a depth-first tree traverser"

  describe "the returned tree" do
    let(:root) { Element.new(children: [first_child, last_child]) }
    let(:first_child) { Element.new(children: [first_grandchild, last_grandchild]) }
    let(:first_grandchild) { Text.new(content: "ABC", box: tall_characters) }
    let(:last_grandchild) { Element.new }
    let(:last_child) { Element.new }

    let(:tall_characters) { Box.new(x: 0, y: 0, width: 60, height: 24) }

    let(:returned_root) { visitor.call(root) }
    let(:returned_first_child) { returned_root.children.first }
    let(:returned_first_grandchild) { returned_first_child.children.first }
    let(:returned_last_grandchild) { returned_first_child.children.last }
    let(:returned_last_child) { returned_root.children.last }

    it "returns a new tree" do
      expect(returned_root).not_to eq(root)
    end

    it "adjusts heights for at least some of the new tree" do
      number_of_nodes_with_adjusted_heights = [
        [root,             returned_root],
        [first_child,      returned_first_child],
        [first_grandchild, returned_first_grandchild],
        [last_grandchild,  returned_last_grandchild],
        [last_child,       returned_last_child],
      ]
      .map { |original_node, new_node|
        new_node.height != original_node.height
      }
      .select { |x| x }
      .size

      expect(number_of_nodes_with_adjusted_heights).to be > 1
    end

    it "ensures children fit inside their parent nodes" do
      expect(returned_root.height).to be >=
        returned_first_child.height + returned_last_child.height

      expect(returned_first_child.height).to be >=
        returned_first_grandchild.height + returned_last_grandchild.height
    end
  end
end
