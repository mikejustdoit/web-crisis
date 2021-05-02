require "build_uri"

RSpec.describe BuildUri do
  context "when the URI is already absolute and complete" do
    let(:origin) { "http://www.example.info/home" }
    let(:uri) { "https://www.example.com/news" }

    it "returns the URI, ignoring the origin URI" do
      expect(
        BuildUri.new(origin: origin).call(uri)
      ).to eq("https://www.example.com/news")
    end
  end

  context "when the URI isn't complete but an origin URI isn't supplied" do
    let(:uri) { "//www.example.com/news" }

    it "complains" do
      expect {
        BuildUri.new.call(uri)
      }.to raise_error(BuildUri::Error)
    end
  end

  context "when the URI is missing a scheme" do
    let(:origin) { "http://www.example.info/home" }
    let(:uri) { "//www.example.com/news" }

    it "builds a new URI using the origin URI's scheme" do
      expect(
        BuildUri.new(origin: origin).call(uri)
      ).to eq("http://www.example.com/news")
    end
  end

  context "when the URI is missing the host" do
    context "and the URI is root-relative" do
      let(:origin) { "http://www.example.info/news" }
      let(:uri) { "/about" }

      it "builds a new URI using the origin URI's host and scheme" do
        expect(
          BuildUri.new(origin: origin).call(uri)
        ).to eq("http://www.example.info/about")
      end
    end

    context "and the URI is relative" do
      let(:origin) { "http://www.example.info/gallery/index.html" }
      let(:uri) { "art.jpg" }

      it "builds a new URI relative to the 'origin'" do
        expect(
          BuildUri.new(origin: origin).call(uri)
        ).to eq("http://www.example.info/gallery/art.jpg")
      end
    end
  end
end
