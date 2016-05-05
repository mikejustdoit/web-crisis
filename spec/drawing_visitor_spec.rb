require "box"
require "drawing_visitor"
require "node"
require "support/gosu_renderer_stubs"
require "text_node"

RSpec.describe DrawingVisitor do
  subject(:drawing_visitor) {
    DrawingVisitor.new(
      box_renderer: box_renderer,
      text_renderer: text_renderer,
    )
  }
  let(:text_renderer) { gosu_text_renderer_stub }
  let(:box_renderer) { gosu_box_renderer_stub }

  describe "drawing visitor interface" do
    it "supports Nodes" do
      expect(drawing_visitor).to respond_to(:draw_box)
    end

    it "supports TextNodes" do
      expect(drawing_visitor).to respond_to(:draw_text)
    end
  end

  describe "delegating drawing tasks to renderers" do
    describe "drawing text" do
      let(:node) { TextNode.new(box: box, content: text) }
      let(:text) { "Please, make yourself at home." }
      let(:box) { Box.new(0, 1, 2, 3) }

      before do
        drawing_visitor.draw_text(node)
      end

      it "delegates the actual drawing to the text renderer" do
        expect(text_renderer).to have_received(:call).with(text, box.x, box.y)
      end
    end

    describe "drawing boxes" do
      let(:node) { Node.new(box: box) }
      let(:box) { Box.new(*box_attributes) }
      let(:box_attributes) { [0, 1, 2, 3] }

      before do
        drawing_visitor.draw_box(node)
      end

      it "delegates the actual drawing to the box renderer" do
        expect(box_renderer).to have_received(:call).with(*box_attributes)
      end
    end
  end

  describe "depth-first tree traversal" do
    let(:root) { Node.new(children: children) }
    let(:children) { [Node.new(children: grandchildren), Node.new] }
    let(:grandchildren) { [TextNode.new(content: "ABC"), Node.new] }

    let(:all_nodes) { [root] + children + grandchildren }

    before do
      all_nodes.each do |node|
        allow(node).to receive(:draw).and_call_original
      end

      drawing_visitor.visit(root)
    end

    it "sends #draw to all nodes once in depth-first order" do
      expect(root).to have_received(:draw).ordered
      expect(children.first).to have_received(:draw).ordered
      expect(grandchildren.first).to have_received(:draw).ordered
      expect(grandchildren.last).to have_received(:draw).ordered
      expect(children.last).to have_received(:draw).ordered
    end
  end
end
