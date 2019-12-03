require "element"
require "engine"

RSpec.describe Engine do
  subject(:engine) {
    Engine.new(
      fetcher: fetcher,
      image_store_factory: image_store_factory,
      layout_visitors: layout_visitors,
      parser: parser,
    )
  }

  let(:fetcher) { double(:fetcher, :call => nil) }
  let(:image_store_factory) {
    double(
      :image_store_factory,
      :call => double(:image_store, :[] => nil),
    )
  }
  let(:layout_visitors) { double(:layout_visitors, :visit => a_tree) }
  let(:parser) { double(:parser, :call => nil) }

  let(:a_tree) { Element.new }

  describe "relationship with its collaborators" do
    before do
      engine.request(
        "https://weworkremotely.com/",
        viewport_width: 640,
        viewport_height: 480,
        text_calculator: double(:text_calculator),
        image_calculator: double(:image_calculator),
      )
    end

    it "calls its callable collaborators" do
      expect(fetcher).to have_received(:call)
      expect(parser).to have_received(:call)
    end

    it "builds its image store with the current 'origin' URI" do
      expect(image_store_factory).to have_received(:call)
        .with(origin: "https://weworkremotely.com/")
    end

    it "starts its visitors visiting" do
      expect(layout_visitors).to have_received(:visit)
    end
  end

  describe "#fetch returning a layed-out tree" do
    let(:returned_tree) {
      engine.request(
        "https://weworkremotely.com/",
        viewport_width: 640,
        viewport_height: 480,
        text_calculator: double(:text_calculator),
        image_calculator: double(:image_calculator),
      )
    }

    it "should return a tree alright" do
      expect(returned_tree).to respond_to(:children)
    end
  end
end
