require "drawing_visitor"

RSpec.describe DrawingVisitor do
  subject(:drawing_visitor) {
    DrawingVisitor.new(
      box_renderer: box_renderer,
      text_renderer: text_renderer,
    )
  }
  let(:text_renderer) { double(:text_renderer, :call => nil) }
  let(:box_renderer) { double(:box_renderer, :call => nil) }

  describe "drawing text" do
    let(:text) { "Please, make yourself at home." }

    before do
      drawing_visitor.draw_text(text)
    end

    it "delegates the actual drawing to the text renderer" do
      expect(text_renderer).to have_received(:call).with(text)
    end
  end

  describe "drawing boxes" do
    let(:box_attributes) { [0, 1, 2, 3] }

    before do
      drawing_visitor.draw_box(*box_attributes)
    end

    it "delegates the actual drawing to the box renderer" do
      expect(box_renderer).to have_received(:call).with(*box_attributes)
    end
  end
end
