require "block_level_element"
require "box"
require "children_positioner"
require "element"
require "inline_element"

RSpec.describe ChildrenPositioner do
  subject(:positioner) { ChildrenPositioner.new }

  describe "positioning a node's first child" do
    let(:root) {
      Element.new(box: offset_from_edges, children: [first_child])
    }
    let(:first_child) { Element.new(box: offset_from_edges) }
    let(:offset_from_edges) { Box.new(x: 100, y: 100, width: 0, height: 0) }

    let(:positioned_children) { positioner.call(root) }
    let(:positioned_first_child) { positioned_children.first }

    it "positions first child relatively at left edge of its parent_node" do
      expect(positioned_first_child.x).to eq(0)
    end

    it "positions first child relatively at top of its parent_node" do
      expect(positioned_first_child.y).to eq(0)
    end
  end

  describe "positioning a node's subsequent children" do
    let(:root) {
      Element.new(
        children: [first_child, middle_child, last_child],
      )
    }
    let(:box_of_some_size) { Box.new(x: 0, y: 0, width: 5, height: 8) }

    context "a block-level node" do
      let(:first_child) { InlineElement.new(Element.new(box: box_of_some_size)) }
      let(:middle_child) { BlockLevelElement.new(Element.new(box: box_of_some_size)) }
      let(:last_child) { BlockLevelElement.new(Element.new(box: box_of_some_size)) }

      let(:positioned_children) { positioner.call(root) }
      let(:positioned_first_child) { positioned_children.first }
      let(:positioned_middle_child) { positioned_children[1] }
      let(:positioned_last_child) { positioned_children.last }

      context "after an inline node" do
        it "positions below its preceding sibling" do
          expect(positioned_middle_child.y).to be >=
            positioned_first_child.bottom
        end

        it "left-aligns with its preceding sibling" do
          expect(positioned_middle_child.x).to eq(positioned_first_child.x)
        end
      end

      context "after another block-level node" do
        it "positions below its preceding sibling" do
          expect(positioned_last_child.y).to be >=
            positioned_middle_child.bottom
        end

        it "left-aligns with its preceding sibling" do
          expect(positioned_last_child.x).to eq(positioned_middle_child.x)
        end
      end
    end

    context "an inline node" do
      let(:first_child) { BlockLevelElement.new(Element.new(box: box_of_some_size)) }
      let(:middle_child) { InlineElement.new(Element.new(box: box_of_some_size)) }
      let(:last_child) { InlineElement.new(Element.new(box: box_of_some_size)) }

      let(:positioned_children) { positioner.call(root) }
      let(:positioned_first_child) { positioned_children.first }
      let(:positioned_middle_child) { positioned_children[1] }
      let(:positioned_last_child) { positioned_children.last }

      context "after a block-level node" do
        it "positions below its preceding sibling" do
          expect(positioned_middle_child.y).to be >=
            positioned_first_child.bottom
        end

        it "left-aligns with its preceding sibling" do
          expect(positioned_middle_child.x).to eq(positioned_first_child.x)
        end
      end

      context "after another inline node" do
        it "positions to the right of its preceding sibling" do
          expect(positioned_last_child.x).to be >=
            positioned_middle_child.right
        end

        it "top-aligns with its preceding sibling" do
          expect(positioned_last_child.y).to eq(positioned_middle_child.y)
        end
      end
    end
  end
end
