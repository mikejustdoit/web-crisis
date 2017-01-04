require "element"
require "first_child_positioner"

RSpec.describe FirstChildPositioner do
  describe "positioning" do
    subject(:calculator) {
      FirstChildPositioner.new
    }
    let(:first_child) { Element.new }

    let(:positioned_first_child) {
      calculator.call(first_child)
    }

    it "positions first child relatively at left edge of its parent_node" do
      expect(positioned_first_child.x).to eq(0)
    end

    it "positions first child relatively at top of its parent_node" do
      expect(positioned_first_child.y).to eq(0)
    end
  end
end
