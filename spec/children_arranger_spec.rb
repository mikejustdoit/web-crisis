require "block_level_element"
require "box"
require "children_arranger"
require "element"
require "inline_element"

RSpec.describe ChildrenArranger do
  describe "positioning the first node in the group" do
    let(:first_node) { Element.new(box: offset_from_edges) }
    let(:offset_from_edges) { Box.new(x: 100, y: 100, width: 0, height: 0) }

    let(:arranged_nodes) { ChildrenArranger.new([first_node]).call }
    let(:arranged_first_node) { arranged_nodes.first }

    it "positions first node relatively at left edge of its parent" do
      expect(arranged_first_node.x).to eq(0)
    end

    it "positions first node relatively at top of its parent" do
      expect(arranged_first_node.y).to eq(0)
    end
  end

  describe "arranging the subsequent nodes in a group" do
    let(:box_of_some_size) { Box.new(x: 0, y: 0, width: 5, height: 8) }

    context "a block-level node" do
      let(:first_node) { InlineElement.new(Element.new(box: box_of_some_size)) }
      let(:middle_node) { BlockLevelElement.new(Element.new(box: box_of_some_size)) }
      let(:last_node) { BlockLevelElement.new(Element.new(box: box_of_some_size)) }

      let(:arranged_nodes) {
        ChildrenArranger.new([first_node, middle_node, last_node]).call
      }
      let(:arranged_first_node) { arranged_nodes.first }
      let(:arranged_middle_node) { arranged_nodes[1] }
      let(:arranged_last_node) { arranged_nodes.last }

      context "after an inline node" do
        it "positions below its preceding sibling" do
          expect(arranged_middle_node.y).to be >=
            arranged_first_node.bottom
        end

        it "left-aligns with its preceding sibling" do
          expect(arranged_middle_node.x).to eq(arranged_first_node.x)
        end
      end

      context "after another block-level node" do
        it "positions below its preceding sibling" do
          expect(arranged_last_node.y).to be >=
            arranged_middle_node.bottom
        end

        it "left-aligns with its preceding sibling" do
          expect(arranged_last_node.x).to eq(arranged_middle_node.x)
        end
      end
    end

    context "an inline node" do
      let(:first_node) { BlockLevelElement.new(Element.new(box: box_of_some_size)) }
      let(:middle_node) { InlineElement.new(Element.new(box: box_of_some_size)) }
      let(:last_node) { InlineElement.new(Element.new(box: box_of_some_size)) }

      let(:arranged_nodes) {
        ChildrenArranger.new([first_node, middle_node, last_node]).call
      }
      let(:arranged_first_node) { arranged_nodes.first }
      let(:arranged_middle_node) { arranged_nodes[1] }
      let(:arranged_last_node) { arranged_nodes.last }

      context "after a block-level node" do
        it "positions below its preceding sibling" do
          expect(arranged_middle_node.y).to be >=
            arranged_first_node.bottom
        end

        it "left-aligns with its preceding sibling" do
          expect(arranged_middle_node.x).to eq(arranged_first_node.x)
        end
      end

      context "after another inline node" do
        it "positions to the right of its preceding sibling" do
          expect(arranged_last_node.x).to be >=
            arranged_middle_node.right
        end

        it "top-aligns with its preceding sibling" do
          expect(arranged_last_node.y).to eq(arranged_middle_node.y)
        end
      end
    end
  end
end
