require "arranger"
require "box"
require "inline_element"
require "support/shared_examples/visitor"

RSpec.describe Arranger do
  subject(:visitor) { Arranger.new }

  it_behaves_like "a visitor"

  describe "the returned tree" do
    let(:root) { Element.new(children: [first_child, last_child]) }
    let(:first_child) {
      Element.new(
        box: a_box_of_height,
        children: [first_grandchild, middle_grandchild],
      )
    }
    let(:first_grandchild) { Text.new(box: a_box_of_height, content: "ABC") }
    let(:middle_grandchild) {
      InlineElement.new(Element.new(box: a_box_of_height, children: []))
    }
    let(:last_child) { Element.new(children: [last_grandchild]) }
    let(:last_grandchild) { Element.new }

    let(:a_box_of_height) { Box.new(x: 0, y: 0, width: 51, height: 11) }

    let(:returned_root) { visitor.call(root) }

    it "returns a new tree" do
      expect(returned_root).not_to eq(root)
    end
  end

  describe "arranging the first node in the group" do
    let(:root) { Element.new(children: [first_child]) }
    let(:first_child) { Element.new(box: offset_from_edges) }
    let(:offset_from_edges) { Box.new(x: 100, y: 100, width: 0, height: 0) }

    let(:arranged_children) { visitor.call(root).children }
    let(:arranged_first_child) { arranged_children.first }

    it "positions first node relatively at left edge of its parent" do
      expect(arranged_first_child.x).to eq(0)
    end

    it "positions first node relatively at top of its parent" do
      expect(arranged_first_child.y).to eq(0)
    end
  end

  describe "arranging the subsequent nodes in a group" do
    let(:box_of_some_size) { Box.new(x: 0, y: 0, width: 5, height: 8) }

    context "a block-level node" do
      let(:root) { Element.new(children: [first_child, middle_child, last_child]) }
      let(:first_child) { InlineElement.new(Element.new(box: box_of_some_size)) }
      let(:middle_child) { BlockLevelElement.new(Element.new(box: box_of_some_size)) }
      let(:last_child) { BlockLevelElement.new(Element.new(box: box_of_some_size)) }

      let(:arranged_children) { visitor.call(root).children }
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
      let(:root) { Element.new(children: [first_child, middle_child, last_child]) }
      let(:first_child) { BlockLevelElement.new(Element.new(box: box_of_some_size)) }
      let(:middle_child) { InlineElement.new(Element.new(box: box_of_some_size)) }
      let(:last_child) { InlineElement.new(Element.new(box: box_of_some_size)) }

      let(:arranged_children) { visitor.call(root).children }
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
