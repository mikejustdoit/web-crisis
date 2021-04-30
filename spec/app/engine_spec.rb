require "element"
require "engine"

RSpec.describe Engine do
  subject(:engine) {
    Engine.new(
      drawing_visitors: drawing_visitors,
      fetcher: fetcher,
      image_store_factory: image_store_factory,
      layout_visitors: layout_visitors,
      parser: parser,
    )
  }

  let(:drawing_visitors) { double(:drawing_visitors, :visit => a_tree) }
  let(:fetcher) { double(:fetcher, :call => nil) }
  let(:image_store_factory) {
    double(
      :image_store_factory,
      :call => double(:image_store, :call => nil),
    )
  }
  let(:layout_visitors) { double(:layout_visitors, :visit => a_tree) }
  let(:parser) {
    double(:parser, :call => nil, :supported_mime_types => %w{text/html})
  }

  let(:a_tree) { Element.new }

  describe "relationship with its collaborators" do
    before do
      engine.uri = "http://www.drchip.org/astronaut/vim/index.html"

      engine.render(
        viewport_width: 640,
        viewport_height: 480,
        text_calculator: double(:text_calculator),
        image_calculator: double(:image_calculator),
        box_renderer: double(:box_renderer),
        image_renderer: double(:image_renderer),
        text_renderer: double(:text_renderer),
      )
    end

    it "calls its callable collaborators" do
      expect(fetcher).to have_received(:call)
      expect(parser).to have_received(:call)
    end

    it "builds its image store with the current 'origin' URI" do
      expect(image_store_factory).to have_received(:call)
        .with(origin: "http://www.drchip.org/astronaut/vim/index.html")
    end

    it "starts its visitors visiting" do
      expect(layout_visitors).to have_received(:visit)
      expect(drawing_visitors).to have_received(:visit)
    end
  end

  describe "#fetch returning a layed-out tree" do
    let(:returned_tree) {
      engine.uri = "http://www.drchip.org/astronaut/vim/index.html"

      engine.render(
        viewport_width: 640,
        viewport_height: 480,
        text_calculator: double(:text_calculator),
        image_calculator: double(:image_calculator),
        box_renderer: double(:box_renderer),
        image_renderer: double(:image_renderer),
        text_renderer: double(:text_renderer),
      )
    }

    it "should return a tree alright" do
      expect(returned_tree).to respond_to(:children)
    end
  end
end
