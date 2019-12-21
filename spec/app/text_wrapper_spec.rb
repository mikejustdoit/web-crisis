require "box"
require "build_text"
require "support/gosu_adapter_stubs"
require "text"
require "text_bounds"
require "text_wrapper"

RSpec.describe TextWrapper do
  subject(:text_wrapper) {
    TextWrapper.new(
      input_text,
      text_calculator: gosu_text_calculator_stub(returns: [20, 18]),
      maximum_bounds: maximum_bounds,
    )
  }

  describe "not wrapping" do
    context "when total width's within maximum_bounds" do
      let(:input_text) {
        BuildText.new.call(
          content: "An excellent opportunity.",
          box: Box.new(x: 0, y: 0, height: 20),
        )
      }
      let(:maximum_bounds) { TextBounds.new(x: 0, width: 1500) }

      let(:wrapped_text) {
        text_wrapper.call
      }

      it "produces a single text node" do
        expect(wrapped_text).to be_a(Text)
      end

      it "produces a single row of text" do
        expect(wrapped_text.rows.size).to eq(1)
      end

      it "updates the text node's dimensions" do
        expect(
          Box.new(
            x: wrapped_text.x,
            y: wrapped_text.y,
            width: wrapped_text.width,
            height: wrapped_text.height,
          )
        ).not_to eq(
          Box.new(
            x: input_text.x,
            y: input_text.y,
            width: input_text.width,
            height: input_text.height,
          )
        )
      end
    end
  end

  describe "wrapping" do
    context "when total width goes over maximum_bounds's right" do
      let(:input_text) {
        BuildText.new.call(
          content: "An excellent opportunity to purchase this home of great character offering spacious accommodation and benefitting from extensive uPVC double glazing and gas wall heaters.",
          box: Box.new(x: 0, y: 0, height: 20),
        )
      }
      let(:maximum_bounds) { TextBounds.new(x: 0, width: 50) }

      let(:wrapped_text) {
        text_wrapper.call
      }

      it "produces a single text node" do
        expect(wrapped_text).to be_a(Text)
      end

      it "produces multiple rows of text" do
        expect(wrapped_text.rows.size).to be > 1
      end

      it "updates the text node's dimensions" do
        expect(
          Box.new(
            x: wrapped_text.x,
            y: wrapped_text.y,
            width: wrapped_text.width,
            height: wrapped_text.height,
          )
        ).not_to eq(
          Box.new(
            x: input_text.x,
            y: input_text.y,
            width: input_text.width,
            height: input_text.height,
          )
        )
      end
    end
  end
end
