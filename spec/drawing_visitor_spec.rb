require "drawing_visitor"

RSpec.describe DrawingVisitor do
  describe "drawing text" do
    subject(:drawing_visitor) { DrawingVisitor.new(text_renderer) }
    let(:text_renderer) { double(:text_renderer, :call => nil) }

    let(:text) { "Please, make yourself at home." }

    before do
      drawing_visitor.draw_text(text)
    end

    it "delegates the actual drawing to the text renderer" do
      expect(text_renderer).to have_received(:call).with(text)
    end
  end
end
