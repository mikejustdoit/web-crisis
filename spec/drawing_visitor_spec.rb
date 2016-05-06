require "box"
require "drawing_visitor"
require "element"
require "support/gosu_renderer_stubs"
require "support/shared_examples/visitor"
require "text"

RSpec.describe DrawingVisitor do
  subject(:drawing_visitor) {
    DrawingVisitor.new(
      box_renderer: box_renderer,
      text_renderer: text_renderer,
    )
  }
  let(:text_renderer) { gosu_text_renderer_stub }
  let(:box_renderer) { gosu_box_renderer_stub }

  let(:visitor) { drawing_visitor }
  it_behaves_like "a visitor"

  describe "delegating drawing tasks to renderers" do
    describe "drawing text nodes" do
      let(:node) { Text.new(box: box, content: text) }
      let(:text) { "Please, make yourself at home." }
      let(:box) { Box.new(0, 1, 2, 3) }

      before do
        drawing_visitor.visit_text(node)
      end

      it "delegates the actual drawing to the text renderer" do
        expect(text_renderer).to have_received(:call).with(text, box.x, box.y)
      end
    end

    describe "drawing element nodes" do
      let(:node) { Element.new(box: box) }
      let(:box) { Box.new(*box_attributes) }
      let(:box_attributes) { [0, 1, 2, 3] }

      before do
        drawing_visitor.visit_element(node)
      end

      it "delegates the actual drawing to the box renderer" do
        expect(box_renderer).to have_received(:call).with(*box_attributes)
      end
    end
  end

  describe "depth-first tree traversal" do
    let(:root) { Element.new(children: children) }
    let(:children) { [Element.new(children: grandchildren), Element.new] }
    let(:grandchildren) { [Text.new(content: "ABC"), Element.new] }

    let(:all_nodes) { [root] + children + grandchildren }

    before do
      all_nodes.each do |node|
        allow(node).to receive(:accept_visit).and_call_original
      end

      drawing_visitor.visit(root)
    end

    it "visits all nodes once in depth-first order" do
      expect(root).to have_received(:accept_visit)
        .with(drawing_visitor).ordered
      expect(children.first).to have_received(:accept_visit)
        .with(drawing_visitor).ordered
      expect(grandchildren.first).to have_received(:accept_visit)
        .with(drawing_visitor).ordered
      expect(grandchildren.last).to have_received(:accept_visit)
        .with(drawing_visitor).ordered
      expect(children.last).to have_received(:accept_visit)
        .with(drawing_visitor).ordered
    end
  end
end
