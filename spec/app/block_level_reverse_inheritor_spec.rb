require "block_level_reverse_inheritor"
require "block_level_element"
require "build_text"
require "inline_element"
require "support/shared_examples/visitor"

RSpec.describe BlockLevelReverseInheritor do
  subject(:visitor) { BlockLevelReverseInheritor.new }

  it_behaves_like "a visitor"

  it_behaves_like "a depth-first tree traverser"

  context "when an inline element is the ancestor of a block-level element" do
    let(:root) { InlineElement.new(Element.new(children: [child])) }
    let(:child) { BlockLevelElement.new(Element.new) }

    it "turns the inline element into a block-level one" do
      returned_root = visitor.call(root)

      expect(returned_root).to be_a(BlockLevelElement)
    end
  end

  context "when a block-level element is the ancestor of a block-level element" do
    let(:root) { BlockLevelElement.new(Element.new(children: [child])) }
    let(:child) { BlockLevelElement.new(Element.new) }

    it "doesn't change the block-levelness of the ancestor" do
      returned_root = visitor.call(root)

      expect(returned_root).to be_a(BlockLevelElement)
    end
  end

  describe "mismatched siblings" do
    context "when an inline element is the sibling of a block-level element" do
      let(:root) {
        InlineElement.new(Element.new(children: [first_child, last_child]))
      }
      let(:first_child) { InlineElement.new(Element.new) }
      let(:last_child) { BlockLevelElement.new(Element.new) }

      it "doesn't change the inlineness of the sibling element" do
        returned_first_child = visitor.call(root).children.first

        expect(returned_first_child).not_to be_a(BlockLevelElement)
      end
    end
  end

  context "when a node doesn't support children" do
    let(:non_children_node) { BuildText.new.call(content: "ABC") }

    it "doesn't even touch the node" do
      returned_non_children_node = visitor.call(non_children_node)

      expect(returned_non_children_node).to eq(non_children_node)
    end
  end

  describe "handling unrecognised node types" do
    context "when a node supports #children but isn't a recognised type" do
      let(:unrecognised_type_of_node) { Element.new }

      it "complains about the unrecognised node type" do
        expect {
          visitor.call(unrecognised_type_of_node)
        }.to raise_error(BlockLevelReverseInheritor::UnrecognisedNodeType)
      end
    end
  end
end
