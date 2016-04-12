require "engine"

RSpec.describe Engine do
  describe "relationship with its collaborators" do
    subject(:engine) {
      Engine.new(
        fetcher: fetcher,
        drawing_visitor: drawing_visitor,
        layout_visitor_factory: layout_visitor_factory,
        parser: parser,
      )
    }

    let(:fetcher) { double(:fetcher, :call => nil) }
    let(:drawing_visitor) { double(:drawing_visitor, :visit => nil) }
    let(:layout_visitor) { double(:layout_visitor, :visit => nil) }
    let(:layout_visitor_factory) {
      double(:layout_visitor_factory, :call => layout_visitor)
    }
    let(:parser) { double(:parser, :call => nil) }

    before do
      engine.request("https://weworkremotely.com/", 640, 480)
    end

    it "calls its callable collaborators" do
      expect(fetcher).to have_received(:call)
      expect(parser).to have_received(:call)
      expect(layout_visitor_factory).to have_received(:call)
    end

    it "starts its visitors visiting" do
      expect(layout_visitor).to have_received(:visit)
      expect(drawing_visitor).to have_received(:visit)
    end
  end
end
