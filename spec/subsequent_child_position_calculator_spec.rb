require "box"
require "element"
require "subsequent_child_position_calculator"

RSpec.describe SubsequentChildPositionCalculator do
  describe "positioning" do
    subject(:calculator) {
      SubsequentChildPositionCalculator.new(preceding_sibling_node: preceding_sibling_node)
    }
    let(:subsequent_child) { Element.new }
    let(:preceding_sibling_node) { Element.new(box: preceding_sibling_node_box) }
    let(:preceding_sibling_node_box) { Box.new(x: 100, y: 200, width: 300, height: 400) }

    let(:positioned_subsequent_child) {
      calculator.call(subsequent_child)
    }

    it "positions subsequent child at bottom of its preceding sibling" do
      expect(positioned_subsequent_child.y).to eq(preceding_sibling_node.bottom)
    end
  end
end
