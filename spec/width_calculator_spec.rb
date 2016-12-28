require "box"
require "element"
require "support/shared_examples/visitor"
require "text"
require "width_calculator"

RSpec.describe WidthCalculator do
  subject(:visitor) { WidthCalculator.new }

  it_behaves_like "a visitor"

  it_behaves_like "a depth-first tree traverser"

  describe "the returned tree" do
    let(:root) { Element.new(children: [first_child, last_child]) }
    let(:first_child) { Element.new(children: [first_grandchild, last_grandchild]) }
    let(:first_grandchild) { Text.new(content: "ABC", box: three_characters_wide) }
    let(:last_grandchild) { Element.new }
    let(:last_child) { Element.new }

    let(:three_characters_wide) { Box.new(x: 0, y: 0, width: 60, height: 18) }

    let(:returned_root) { visitor.call(root) }
    let(:returned_first_child) { returned_root.children.first }
    let(:returned_first_grandchild) { returned_first_child.children.first }
    let(:returned_last_grandchild) { returned_first_child.children.last }
    let(:returned_last_child) { returned_root.children.last }

    it "returns a new tree" do
      expect(returned_root).not_to eq(root)
    end

    it "adjusts parent nodes to accommodate their children" do
      expect(returned_root.width).to be >=
        returned_first_child.width + returned_last_child.width

      expect(returned_first_child.width).to be >=
        returned_first_grandchild.width + returned_last_grandchild.width
    end
  end
end
