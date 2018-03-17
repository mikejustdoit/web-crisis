require "box"
require "build_text"
require "support/gosu_adapter_stubs"
require "text"
require "text_wrapper"

RSpec.describe TextWrapper do
  subject(:text_wrapper) {
    TextWrapper.new(
      input_text,
      text_width_calculator: gosu_text_width_calculator_stub(returns: 20),
    )
  }

  describe "not wrapping" do
    context "when total width's within right_limit" do
      let(:input_text) {
        BuildText.new.call(
          content: "An excellent opportunity.",
          box: Box.new(x: 0, y: 0, height: 20),
        )
      }

      let(:wrapped_text) {
        text_wrapper.call(right_limit: 1500)
      }

      it "produces a single text node" do
        expect(wrapped_text).to be_a(Text)
      end

      it "produces a single row of text" do
        expect(wrapped_text.rows.size).to eq(1)
      end
    end
  end

  describe "wrapping" do
    context "when total width goes over right_limit" do
      let(:input_text) {
        BuildText.new.call(
          content: "An excellent opportunity to purchase this home of great character offering spacious accommodation and benefitting from extensive uPVC double glazing and gas wall heaters.",
          box: Box.new(x: 0, y: 0, height: 20),
        )
      }

      let(:wrapped_text) {
        text_wrapper.call(right_limit: 50)
      }

      it "produces a single text node" do
        expect(wrapped_text).to be_a(Text)
      end

      it "produces multiple rows of text" do
        expect(wrapped_text.rows.size).to be > 1
      end
    end
  end
end
