require "block_level_element"
require "box"
require "element"
require "element_arranger"
require "inline_element"

RSpec.describe ElementArranger do
  def arrange(element)
    arrange_child = -> (child_node) { child_node }

    ElementArranger.new(element, arrange_child: arrange_child).call
  end
  viewport = Box.new(x: 0, y: 0, width: 640, height: 480)

  describe "arranging the first child node in the group" do
    let(:root) {
      BlockLevelElement.new(Element.new(box: viewport, children: [first_child]))
    }
    let(:first_child) { BlockLevelElement.new(Element.new(box: offset_from_edges)) }
    let(:offset_from_edges) { Box.new(x: 100, y: 100, width: 0, height: 0) }

    let(:arranged_children) { arrange(root).children }
    let(:arranged_first_child) { arranged_children.first }

    it "positions first child node relatively at left edge of its parent" do
      expect(arranged_first_child.x).to eq(0)
    end

    it "positions first child node relatively at top of its parent" do
      expect(arranged_first_child.y).to eq(0)
    end
  end

  describe "arranging the subsequent child nodes in a group" do
    let(:box_of_some_size) { Box.new(x: 0, y: 0, width: 5, height: 8) }

    context "a block-level node" do
      let(:root) {
        Element.new(box: viewport, children: [first_child, middle_child, last_child])
      }
      let(:first_child) { InlineElement.new(Element.new(box: box_of_some_size)) }
      let(:middle_child) { BlockLevelElement.new(Element.new(box: box_of_some_size)) }
      let(:last_child) { BlockLevelElement.new(Element.new(box: box_of_some_size)) }

      let(:arranged_children) { arrange(root).children }
      let(:arranged_first_child) { arranged_children.first }
      let(:arranged_middle_child) { arranged_children[1] }
      let(:arranged_last_child) { arranged_children.last }

      context "after an inline node" do
        it "positions below its preceding sibling" do
          expect(arranged_middle_child.y).to be >=
            arranged_first_child.bottom
        end

        it "left-aligns with its preceding sibling" do
          expect(arranged_middle_child.x).to eq(arranged_first_child.x)
        end
      end

      context "after another block-level node" do
        it "positions below its preceding sibling" do
          expect(arranged_last_child.y).to be >=
            arranged_middle_child.bottom
        end

        it "left-aligns with its preceding sibling" do
          expect(arranged_last_child.x).to eq(arranged_middle_child.x)
        end
      end
    end

    context "an inline node" do
      let(:root) {
        Element.new(box: viewport, children: [first_child, middle_child, last_child])
      }
      let(:first_child) { BlockLevelElement.new(Element.new(box: box_of_some_size)) }
      let(:middle_child) { InlineElement.new(Element.new(box: box_of_some_size)) }
      let(:last_child) { InlineElement.new(Element.new(box: box_of_some_size)) }

      let(:arranged_children) { arrange(root).children }
      let(:arranged_first_child) { arranged_children.first }
      let(:arranged_middle_child) { arranged_children[1] }
      let(:arranged_last_child) { arranged_children.last }

      context "after a block-level node" do
        it "positions below its preceding sibling" do
          expect(arranged_middle_child.y).to be >=
            arranged_first_child.bottom
        end

        it "left-aligns with its preceding sibling" do
          expect(arranged_middle_child.x).to eq(arranged_first_child.x)
        end
      end

      context "after another inline node" do
        it "positions to the right of its preceding sibling" do
          expect(arranged_last_child.x).to be >=
            arranged_middle_child.right
        end

        it "top-aligns with its preceding sibling" do
          expect(arranged_last_child.y).to eq(arranged_middle_child.y)
        end
      end
    end
  end
end
