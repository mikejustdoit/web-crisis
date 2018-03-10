require "block_level_reverse_inheritor"
require "block_level_element"
require "build_text"
require "inline_element"
require "support/shared_examples/visitor"

RSpec.describe BlockLevelReverseInheritor do
  subject(:visitor) { BlockLevelReverseInheritor.new }

  it_behaves_like "a visitor"

  it_behaves_like "a depth-first tree traverser"

  it_behaves_like "a class-centric callable"

  describe "the returned tree" do
    let(:root) {
      InlineElement.new(Element.new(children: [first_child, last_child]))
    }
    let(:first_child) {
      InlineElement.new(
        Element.new(
          children: [first_grandchild, middle_grandchild, last_grandchild],
        )
      )
    }
    let(:first_grandchild) { BuildText.new.call(content: "ABC") }
    let(:middle_grandchild) { BlockLevelElement.new(Element.new) }
    let(:last_grandchild) { InlineElement.new(Element.new) }
    let(:last_child) { InlineElement.new(Element.new) }

    let(:returned_root) { visitor.call(root) }
    let(:returned_first_child) { returned_root.children.first }
    let(:returned_first_grandchild) { returned_first_child.children.first }
    let(:returned_last_grandchild) { returned_first_child.children.last }
    let(:returned_last_child) { returned_root.children.last }

    it "turns inline ancestors of block-level elements block-level" do
      expect(returned_first_child).to be_a BlockLevelElement
      expect(returned_root).to be_a BlockLevelElement
    end

    it "leaves everything else alone" do
      [
        returned_first_grandchild,
        returned_last_grandchild,
        returned_last_child,
      ].each do |node|
        expect(node).not_to be_a BlockLevelElement
      end
    end
  end
end
