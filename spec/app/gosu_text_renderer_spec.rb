require "box"
require "gosu_text_renderer"

RSpec.describe GosuTextRenderer do
  subject(:gosu_text_renderer) { GosuTextRenderer.new(viewport) }
  let(:gosu_font) { double(:gosu_font, :draw => nil) }

  before do
    allow(Gosu::Font).to receive(:new).and_return(gosu_font)
  end

  describe "adapting Gosu::Font" do
    let(:viewport) { Box.new(x: 0, y: 0, width: 200, height: 100) }

    describe "#call" do
      let(:text) { "OHAI" }
      let(:text_x) { 100 }
      let(:text_y) { 50 }

      it "creates a Gosu::Font and draws the text with it" do
        gosu_text_renderer.call(text, x: text_x, y: text_y, colour: :black)

        expect(gosu_font).to have_received(:draw).with(
          text,
          text_x,
          text_y,
          any_args,
        )
      end
    end
  end

  describe "translating for window" do
    let(:viewport) {
      Box.new(
        x: viewport_x,
        y: viewport_y,
        width: viewport_width,
        height: viewport_height,
      )
    }
    let(:viewport_x) { 10 }
    let(:viewport_y) { 10 }
    let(:viewport_width) { 200 }
    let(:viewport_height) { 100 }

    describe "#call" do
      let(:text) { "OHAI" }
      let(:text_x) { 100 }
      let(:text_y) { 50 }

      let(:x_plus_viewport_x) { text_x + viewport_x }
      let(:y_plus_viewport_y) { text_y + viewport_y }

      it "translates the viewport-world position to a window position" do
        gosu_text_renderer.call(text, x: text_x, y: text_y, colour: :black)

        expect(gosu_font).to have_received(:draw).with(
          text,
          x_plus_viewport_x,
          y_plus_viewport_y,
          any_args,
        )
      end
    end
  end
end
