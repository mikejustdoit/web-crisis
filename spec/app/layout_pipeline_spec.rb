require "layout_pipeline"

RSpec.describe LayoutPipeline do
  describe "pipelining visitors" do
    let(:first_visitor_factory) { double(:first_visitor_factory, :call => first_visitor) }
    let(:first_visitor) { double(:first_visitor) }
    let(:second_visitor_factory) { double(:second_visitor_factory, :call => second_visitor) }
    let(:second_visitor) { double(:second_visitor) }

    let(:initial_tree) { double(:initial_tree) }
    let(:intermediate_tree) { double(:intermediate_tree) }
    let(:final_tree) { double(:final_tree) }

    before do
      allow(first_visitor).to receive(:call).with(initial_tree)
        .and_return(intermediate_tree)
      allow(second_visitor).to receive(:call).with(intermediate_tree)
        .and_return(final_tree)
    end

    subject(:layout_pipeline) {
      LayoutPipeline.new(
        [
          first_visitor_factory,
          second_visitor_factory,
        ]
      )
    }
    let(:returned_value) { layout_pipeline.visit(initial_tree) }

    it "returns the very last visitor's tree" do
      expect(returned_value).to eq(final_tree)
    end
  end
end