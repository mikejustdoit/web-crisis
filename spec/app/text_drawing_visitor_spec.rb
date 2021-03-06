require "box"
require "build_text"
require "element"
require "support/gosu_adapter_stubs"
require "support/shared_examples/visitor"
require "text"
require "text_drawing_visitor"
require "text_row"

RSpec.describe TextDrawingVisitor do
  subject(:visitor) {
    TextDrawingVisitor.new(
      text_renderer: text_renderer,
    )
  }
  let(:text_renderer) { gosu_text_renderer_stub }

  it_behaves_like "a visitor"

  it_behaves_like "a depth-first tree traverser"

  describe "the returned tree" do
    let(:root) { Element.new(children: [first_child, last_child]) }
    let(:first_child) { Element.new(children: [first_grandchild, last_grandchild]) }
    let(:first_grandchild) {
      BuildText.new.call(
        box: Box.new(x: 0, y: 0, width: 100, height: 100),
        content: "ABC",
      )
    }
    let(:last_grandchild) { Element.new }
    let(:last_child) { Element.new }

    let(:returned_root) { visitor.call(root) }
    let(:returned_first_child) { returned_root.children.first }
    let(:returned_first_grandchild) { returned_first_child.children.first }
    let(:returned_last_grandchild) { returned_first_child.children.last }
    let(:returned_last_child) { returned_root.children.last }

    it "returns the original tree" do
      expect(returned_root).to eq(root)
      expect(returned_first_child).to eq(first_child)
      expect(returned_first_grandchild).to eq(first_grandchild)
      expect(returned_last_grandchild).to eq(last_grandchild)
      expect(returned_last_child).to eq(last_child)
    end
  end

  describe "delegating drawing task to text renderer" do
    describe "drawing text nodes" do
      let(:node) {
        BuildText.new.call(
          box: Box.new(x: 0, y: 1, width: 2, height: 3),
          content: text,
        )
      }
      let(:text) { "Please, make yourself at home." }
      let(:internal_text_row) { node.rows.first }

      it "delegates the actual drawing to the text renderer" do
        visitor.call(node)

        expect(text_renderer).to have_received(:call).with(
          text,
          x: internal_text_row.x,
          y: internal_text_row.y,
          colour: :black,
        )
      end
    end
  end

  describe "handling non-text nodes" do
    before do
      allow(visitor).to receive(:call).and_call_original
    end

    context "when they support children" do
      let(:node) { Element.new(children: [child]) }
      let(:child) { Element.new }

      it "traverses node's children" do
        visitor.call(node)

        expect(visitor).to have_received(:call).with(child)
      end

      it "returns the node" do
        expect(visitor.call(node)).to eq(node)
      end
    end

    context "when they don't support children" do
      let(:non_children_node) { double(:non_children_node) }

      it "returns the node" do
        expect(visitor.call(non_children_node)).to eq(non_children_node)
      end

      it "doesn't invoke the text renderer" do
        visitor.call(non_children_node)

        expect(text_renderer).not_to have_received(:call)
      end
    end
  end

  describe "drawing text that wraps over multiple rows" do
    let(:node) {
      Text.new(
        box: Box.new(x: 75, y: 1234, width: 200, height: 36),
        rows: [first_row, second_row],
        colour: :black,
      )
    }
    let(:first_row) {
      TextRow.new(
        box: Box.new(x: 75, y: 1234, width: 200, height: 18),
        content: "My Life in Text Wrapping",
      )
    }
    let(:second_row) {
      TextRow.new(
        box: Box.new(x: 75, y: 1252, width: 150, height: 18),
        content: "A true crime special",
      )
    }

    it "draws each row separately at its specified position" do
      visitor.call(node)

      expect(text_renderer).to have_received(:call).with(
        first_row.content,
        x: first_row.x,
        y: first_row.y,
        colour: :black,
      )
      expect(text_renderer).to have_received(:call).with(
        second_row.content,
        x: second_row.x,
        y: second_row.y,
        colour: :black,
      )
    end
  end
end
