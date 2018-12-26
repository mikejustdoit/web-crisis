require "arranger"
require "block_level_element"
require "box"
require "build_text"
require "element"
require "inline_element"
require "node_within_parent"
require "support/gosu_adapter_stubs"

RSpec.describe Arranger do
  subject(:visitor) {
    Arranger.new(
      text_width_calculator: gosu_text_width_calculator_stub(returns: 50),
    )
  }
  let(:viewport) { Box.new(x: 0, y: 0, width: 640, height: 480) }

  describe "visiting elements with children" do
    let(:element) { Element.new(box: box, children: []) }
    let(:box) { Box.new(x: 0, y: 1, width: 2, height: 3) }

    before do
      allow(ElementArranger).to receive(:new).and_call_original
    end

    it "supports elements with children" do
      expect(
        visitor.call(element)
      ).not_to be_nil
    end

    it "delegates arranger to ElementArranger" do
      visitor.call(element)

      expect(ElementArranger).to have_received(:new).with(element, any_args)
    end
  end

  describe "visiting text nodes" do
    let(:text) { BuildText.new.call(box: box, content: "Just passing.") }
    let(:box) { Box.new(x: 0, y: 1, width: 2, height: 3) }
    let(:element) { Element.new(box: box, children: []) }

    before do
      allow(TextWrapper).to receive(:new).and_call_original
    end

    it "supports Text nodes as long as they're wrapped within a parent" do
      expect(
        visitor.call(NodeWithinParent.new(text, element))
      ).not_to be_nil
    end

    it "invokes the TextWrapper" do
      visitor.call(NodeWithinParent.new(text, element))

      expect(TextWrapper).to have_received(:new)
    end
  end

  describe "handling unrecognised node types" do
    context "when a node doesn't support #children and isn't text" do
      let(:unrecognised_type_of_node) { double(:unrecognised_type_of_node) }

      it "complains about the unrecognised node type" do
        expect {
          visitor.call(unrecognised_type_of_node)
        }.to raise_error(UnrecognisedNodeType)
      end
    end
  end

  describe "the returned tree" do
    let(:root) {
      BlockLevelElement.new(
        Element.new(box: viewport, children: [first_child, last_child])
      )
    }
    let(:first_child) {
      BlockLevelElement.new(
        Element.new(
          box: a_box_of_height,
          children: [first_grandchild, middle_grandchild],
        )
      )
    }
    let(:first_grandchild) { BuildText.new.call(box: a_box_of_height, content: "ABC") }
    let(:middle_grandchild) {
      InlineElement.new(Element.new(box: a_box_of_height, children: []))
    }
    let(:last_child) {
      BlockLevelElement.new(Element.new(children: [last_grandchild]))
    }
    let(:last_grandchild) { BlockLevelElement.new(Element.new) }

    let(:a_box_of_height) { Box.new(x: 0, y: 0, width: 51, height: 11) }

    let(:returned_root) { visitor.call(root) }

    it "returns a new tree" do
      expect(returned_root).not_to eq(root)
    end
  end
end
