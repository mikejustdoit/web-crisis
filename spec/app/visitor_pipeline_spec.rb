require "visitor_pipeline"

RSpec.describe VisitorPipeline do
    let(:first_visitor_factory) {
      double(:first_visitor_factory, call: first_visitor)
    }
    let(:second_visitor_factory) {
      double(:second_visitor_factory, call: second_visitor)
    }

    let(:first_visitor) { double(:first_visitor, call: intermediate_tree) }
    let(:second_visitor) { double(:second_visitor, call: final_tree) }

    let(:initial_tree) { double(:initial_tree) }
    let(:intermediate_tree) { double(:intermediate_tree) }
    let(:final_tree) { double(:final_tree) }

    subject(:visitor_pipeline) {
      VisitorPipeline.new([first_visitor_factory, second_visitor_factory])
    }

    describe "building the visitor objects from the provided factories" do
      it "invokes each factory and supplies a hash representing the app context" do
        app_context = {}

        visitor_pipeline.visit(initial_tree, **app_context)

        expect(first_visitor_factory).to have_received(:call).with(app_context)
        expect(second_visitor_factory).to have_received(:call).with(app_context)
      end
    end

    describe "invoking each visitor in turn" do
      it "passes the initial input tree to first visitor" do
        visitor_pipeline.visit(initial_tree)

        expect(first_visitor).to have_received(:call).with(initial_tree)
      end

      it "passes the subsequent visitors the return value of the previous visitor" do
        visitor_pipeline.visit(initial_tree)

        expect(second_visitor).to have_received(:call).with(intermediate_tree)
      end

      it "returns the final visitor's output" do
        expect(
          visitor_pipeline.visit(initial_tree)
        ).to eq(final_tree)
      end
    end
end
