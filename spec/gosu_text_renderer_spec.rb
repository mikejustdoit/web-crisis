require "gosu_text_renderer"

RSpec.describe GosuTextRenderer do
  describe "adapting Gosu::Font" do
    subject(:gosu_text_renderer) { GosuTextRenderer.new }
    let(:gosu_font) { double(:gosu_font, :draw => nil) }

    before do
      allow(Gosu::Font).to receive(:new).and_return(gosu_font)
    end

    describe "#call" do
      let(:text) { "OHAI" }
      let(:text_x) { 100 }
      let(:text_y) { 50 }

      before do
        gosu_text_renderer.call(text, text_x, text_y)
      end

      it "creates a Gosu::Font and draws the text with it" do
        expect(gosu_font).to have_received(:draw).with(
          text,
          text_x,
          text_y,
          any_args,
        )
      end
    end
  end
end
