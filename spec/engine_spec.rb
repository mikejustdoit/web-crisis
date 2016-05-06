require "element"
require "engine"

RSpec.describe Engine do
  subject(:engine) {
    Engine.new(
      fetcher: fetcher,
      layout_visitor_factory: layout_visitor_factory,
      parser: parser,
    )
  }

  let(:fetcher) { double(:fetcher, :call => nil) }
  let(:layout_visitor) { double(:layout_visitor, :visit => a_tree) }
  let(:layout_visitor_factory) {
    double(:layout_visitor_factory, :call => layout_visitor)
  }
  let(:parser) { double(:parser, :call => nil) }

  let(:a_tree) { Element.new }

  describe "relationship with its collaborators" do
    before do
      engine.request(
        "https://weworkremotely.com/",
        640,
        480,
      )
    end

    it "calls its callable collaborators" do
      expect(fetcher).to have_received(:call)
      expect(parser).to have_received(:call)
      expect(layout_visitor_factory).to have_received(:call)
    end

    it "starts its visitors visiting" do
      expect(layout_visitor).to have_received(:visit)
    end
  end

  describe "#fetch returning a layed-out tree" do
    let(:returned_tree) {
      engine.request(
        "https://weworkremotely.com/",
        640,
        480,
      )
    }

    it "should return a tree alright" do
      expect(returned_tree).to respond_to(:children)
    end
  end
end
