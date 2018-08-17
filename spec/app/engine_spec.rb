require "element"
require "engine"

RSpec.describe Engine do
  subject(:engine) {
    Engine.new(
      fetcher: fetcher,
      layout_pipeline: layout_pipeline,
      parser: parser,
    )
  }

  let(:fetcher) { double(:fetcher, :call => nil) }
  let(:layout_pipeline) { double(:layout_pipeline, :visit => a_tree) }
  let(:parser) { double(:parser, :call => nil) }

  let(:a_tree) { Element.new }

  describe "relationship with its collaborators" do
    before do
      engine.request(
        "https://weworkremotely.com/",
        viewport_width: 640,
        viewport_height: 480,
        text_width_calculator: double(:text_width_calculator),
        image_dimensions_calculator: double(:image_dimensions_calculator),
      )
    end

    it "calls its callable collaborators" do
      expect(fetcher).to have_received(:call)
      expect(parser).to have_received(:call)
    end

    it "starts its visitors visiting" do
      expect(layout_pipeline).to have_received(:visit)
    end
  end

  describe "#fetch returning a layed-out tree" do
    let(:returned_tree) {
      engine.request(
        "https://weworkremotely.com/",
        viewport_width: 640,
        viewport_height: 480,
        text_width_calculator: double(:text_width_calculator),
        image_dimensions_calculator: double(:image_dimensions_calculator),
      )
    }

    it "should return a tree alright" do
      expect(returned_tree).to respond_to(:children)
    end
  end
end
