require "box"
require "build_text"
require "root_node_drawing_visitor"
require "element"
require "support/gosu_adapter_stubs"
require "support/shared_examples/visitor"

RSpec.describe RootNodeDrawingVisitor do
  subject(:visitor) {
    RootNodeDrawingVisitor.new(
      box_renderer: box_renderer,
    )
  }
  let(:box_renderer) { gosu_box_renderer_stub }

  it_behaves_like "a visitor"

  describe "the returned tree" do
    let(:root) { Element.new(children: [first_child, last_child]) }
    let(:first_child) { Element.new(children: [first_grandchild, last_grandchild]) }
    let(:first_grandchild) { BuildText.new.call(content: "ABC") }
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

  describe "delegating drawing task to box renderer" do
    let(:box) { Box.new(**box_attributes) }
    let(:box_attributes) { {:x => 0, :y => 1, :width => 2, :height => 3} }

    describe "drawing a text root node" do
      let(:node) {
        BuildText.new.call(
          box: box,
          content: "Please, make yourself at home.",
        )
      }

      before do
        visitor.call(node)
      end

      it "delegates the actual drawing to the box renderer" do
        expect(box_renderer).to have_received(:call).with(*box_attributes.values)
      end
    end

    describe "drawing an element root node" do
      let(:node) { Element.new(box: box) }

      before do
        visitor.call(node)
      end

      it "delegates the actual drawing to the box renderer" do
        expect(box_renderer).to have_received(:call).with(*box_attributes.values)
      end
    end
  end
end
