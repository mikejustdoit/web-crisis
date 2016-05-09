require "box"
require "drawing_visitor"
require "element"
require "support/gosu_renderer_stubs"
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

  describe "delegating drawing tasks to renderers" do
    describe "drawing text nodes" do
      let(:node) { Text.new(box: box, content: text) }
      let(:text) { "Please, make yourself at home." }
      let(:box) { Box.new(0, 1, 2, 3) }

      before do
        visitor.visit_text(node)
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
        visitor.visit_element(node)
      end

      it "delegates the actual drawing to the box renderer" do
        expect(box_renderer).to have_received(:call).with(*box_attributes)
      end
    end
  end
end
