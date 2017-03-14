require "box"
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
        Text.new(
          content: "An excellent opportunity.",
        )
      }

      let(:wrapped_texts) {
        return *text_wrapper.call(right_limit: 1500)
      }

      it "produces a single text node" do
        expect(wrapped_texts.size).to eq(1)
      end

      it "returns content intact" do
        expect(wrapped_texts.first.content).to eq(input_text.content)
      end
    end
  end

  describe "wrapping" do
    context "when total width goes over right_limit" do
      let(:input_text) {
        Text.new(
          content: "An excellent opportunity to purchase this home of great character offering spacious accommodation and benefitting from extensive uPVC double glazing and gas wall heaters.",
        )
      }

      let(:wrapped_texts) {
        return *text_wrapper.call(right_limit: 50)
      }

      it "produces multiple text nodes" do
        expect(wrapped_texts.size).to be > 1
      end

      it "splits content over those nodes" do
        expect(
          Element.new(children: wrapped_texts).content
        ).to eq(input_text.content)
      end
    end
  end
end
