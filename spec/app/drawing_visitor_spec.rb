require "box"
require "build_text"
require "drawing_visitor"
require "element"
require "support/gosu_adapter_stubs"
require "support/shared_examples/visitor"
require "text"

RSpec.describe DrawingVisitor do
  subject(:visitor) {
    DrawingVisitor.new(
      box_renderer: box_renderer,
      text_renderer: text_renderer,
    )
  }
  let(:text_renderer) { gosu_text_renderer_stub }
  let(:box_renderer) { gosu_box_renderer_stub }

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

  describe "delegating drawing tasks to renderers" do
    describe "drawing text nodes" do
      let(:node) { BuildText.new.call(box: box, content: text) }
      let(:text) { "Please, make yourself at home." }
      let(:box) { Box.new(x: 0, y: 1, width: 2, height: 3) }

      before do
        visitor.call(node)
      end

      it "delegates the actual drawing to the text renderer" do
        expect(text_renderer).to have_received(:call).with(text, box.x, box.y)
      end
    end

    describe "drawing element nodes" do
      let(:node) { Element.new(box: box) }
      let(:box) { Box.new(**box_attributes) }
      let(:box_attributes) { {:x => 0, :y => 1, :width => 2, :height => 3} }

      before do
        visitor.call(node)
      end

      it "delegates the actual drawing to the box renderer" do
        expect(box_renderer).to have_received(:call).with(*box_attributes.values)
      end
    end
  end

  describe "drawing text that wraps over multiple rows" do
    let(:node) {
      Text.new(
        position: Point.new(x: 75, y: 1234),
        rows: [first_row, second_row],
      )
    }
    let(:first_row) {
      TextRow.new(
        box: Box.new(x: 0, y: 0, width: 200, height: 18),
        content: "My Life in Text Wrapping",
      )
    }
    let(:second_row) {
      TextRow.new(
        box: Box.new(x: 0, y: 18, width: 150, height: 18),
        content: "A true crime special",
      )
    }

    before do
      visitor.call(node)
    end

    it "draws each row separately, with absolute position" do
      expect(text_renderer).to have_received(:call).with(
        first_row.content,
        node.x + first_row.x,
        node.y + first_row.y,
      )
      expect(text_renderer).to have_received(:call).with(
        second_row.content,
        node.x + second_row.x,
        node.y + second_row.y,
      )
    end
  end
end
