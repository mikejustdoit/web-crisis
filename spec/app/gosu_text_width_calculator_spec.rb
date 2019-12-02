require "gosu_text_width_calculator"

RSpec.describe GosuTextWidthCalculator do
  subject(:gosu_text_width_calculator) { GosuTextWidthCalculator.new }
  let(:gosu_font) { double(:gosu_font, :text_width => canned_text_width) }
  let(:canned_text_width) { 220 }

  before do
    allow(Gosu::Font).to receive(:new).and_return(gosu_font)
  end

  describe "adapting Gosu::Font" do
    describe "#call" do
      let(:text) { "OHAI" }

      before do
        @calculation = gosu_text_width_calculator.call(text)
      end

      it "creates a Gosu::Font and calculates the text's width with it" do
        expect(gosu_font).to have_received(:text_width).with(
          text,
        )
      end

      it "propagates Gosu::Font#text_width and its own hard-coded line height" do
        expect(@calculation).to eq([canned_text_width, 18])
      end
    end
  end
end
