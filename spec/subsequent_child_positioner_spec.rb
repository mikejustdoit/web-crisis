require "box"
require "element"
require "subsequent_child_positioner"

RSpec.describe SubsequentChildPositioner do
  describe "positioning" do
    subject(:calculator) {
      SubsequentChildPositioner.new
    }
    let(:preceding_sibling_node_box) { Box.new(x: 100, y: 200, width: 300, height: 400) }

    let(:positioned_subsequent_child) {
      calculator.call(
        subsequent_child,
        preceding_sibling_node: preceding_sibling_node,
      )
    }

    context "a block-level node" do
      let(:subsequent_child) { Element.new }

      context "after another block-level node" do
        let(:preceding_sibling_node) {
          Element.new(box: preceding_sibling_node_box)
        }

        it "positions subsequent child below its preceding sibling" do
          expect(positioned_subsequent_child.y).to eq(preceding_sibling_node.bottom)
        end
      end

      context "after an inline node" do
        let(:preceding_sibling_node) {
          Text.new(box: preceding_sibling_node_box, content: "Don't be a stranger")
        }

        it "positions subsequent child below its preceding sibling" do
          expect(positioned_subsequent_child.y).to eq(preceding_sibling_node.bottom)
        end
      end
    end

    context "an inline node" do
      let(:subsequent_child) { Text.new(content: "Can I join you?") }

      context "after a block-level node" do
        let(:preceding_sibling_node) {
          Element.new(box: preceding_sibling_node_box)
        }

        it "positions subsequent child below its preceding sibling" do
          expect(positioned_subsequent_child.y).to eq(preceding_sibling_node.bottom)
        end
      end

      context "after another inline node" do
        let(:preceding_sibling_node) {
          Text.new(box: preceding_sibling_node_box, content: "Let's be friends")
        }

        it "positions subsequent child to the left of its preceding sibling" do
          expect(positioned_subsequent_child.x).to eq(preceding_sibling_node.right)
          expect(positioned_subsequent_child.y).to eq(preceding_sibling_node.y)
        end
      end
    end
  end
end
