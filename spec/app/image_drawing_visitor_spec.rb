require "box"
require "element"
require "image"
require "image_drawing_visitor"
require "support/gosu_adapter_stubs"
require "support/shared_examples/visitor"

RSpec.describe ImageDrawingVisitor do
  subject(:visitor) {
    ImageDrawingVisitor.new(
      image_renderer: image_renderer,
    )
  }
  let(:image_renderer) { gosu_image_renderer_stub }

  it_behaves_like "a visitor"

  it_behaves_like "a depth-first tree traverser"

  describe "the returned tree" do
    let(:root) { Element.new(children: [first_child, last_child]) }
    let(:first_child) { Element.new(children: [first_grandchild, last_grandchild]) }
    let(:first_grandchild) {
      Image.new(
        box: Box.new(x: 0, y: 0, width: 100, height: 100),
        src: "https://www.example.com/art.jpg",
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

  describe "delegating drawing task to image renderer" do
    describe "drawing text nodes" do
      let(:node) {
        Image.new(
          box: Box.new(x: 50, y: 22, width: 100, height: 100),
          src: "https://www.example.com/art.jpg",
          filename: "art.jpg",
        )
      }

      it "delegates the actual drawing to the image renderer" do
        visitor.call(node)

        expect(image_renderer).to have_received(:call).with("art.jpg", 50, 22)
      end
    end
  end

  describe "handling non-image nodes" do
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

      it "doesn't invoke the image renderer" do
        visitor.call(non_children_node)

        expect(image_renderer).not_to have_received(:call)
      end
    end
  end
end
