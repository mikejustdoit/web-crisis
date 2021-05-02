require "image_store"
require "support/shared_examples/image_store"

RSpec.describe ImageStore do
  subject(:store) { ImageStore.new(fetcher: fetcher, origin: origin) }
  let(:fetcher) { double(:fetcher, :call => "ABCIMAGECONTENTS") }
  let(:origin) { "https://www.example.com/gallery.html" }

  before do
    stub_const("LOGGER", double(:logger, :call => nil))

    allow(File).to receive(:open).and_yield(file)
    allow(file).to receive(:print).and_call_original
  end
  let(:file) { StringIO.new }

  let(:src) { "https://www.example.com/art.jpg" }
  let(:supported_mime_types) { %w{image/gif image/jpeg image/png} }

  describe "implements the image store interface" do
    include_examples "the image store interface"
  end

  it "fetches the image" do
    store.call(src)

    expect(fetcher).to have_received(:call).with(src, accept: supported_mime_types)
  end

  it "writes the image to disk" do
    store.call(src)

    expect(file).to have_received(:print)
  end

  it "returns the filename of the image on disk" do
    image_filename = store.call(src)

    expect(image_filename).to match(/art\.jpg/)
  end

  context "when something goes wrong" do
    before do
      allow(fetcher).to receive(:call).and_raise(StandardError.new("bad internet"))
    end

    let(:src) { "https://www.example.com/art.jpg" }

    it "falls back to our placeholder image" do
      image_filename = store.call(src)

      expect(image_filename).to eq(PLACEHOLDER_IMAGE)
    end

    it "logs the error and the URI in question" do
      store.call(src)

      expect(LOGGER).to have_received(:call).with(
        /StandardError.*bad internet.*https:\/\/www\.example\.com\/art\.jpg/
      )
    end
  end

  context "when the URI is data (data scheme)" do
    let(:src) { "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAEDWlDQ1BJQ0MgUHJvZmlsZQAAOI2NVV1oHFUUPrtzZyMkzlNsNIV0qD8NJQ2TVjShtLp/3d02bpZJNtoi6GT27s6Yyc44M7v9oU9FUHwx6psUxL+3gCAo9Q/bPrQvlQol2tQgKD60+INQ6Ium65k7M5lpurHeZe58853vnnvuuWfvBei5qliWkRQBFpquLRcy4nOHj4g9K5CEh6AXBqFXUR0rXalMAjZPC3e1W99Dwntf2dXd/p+tt0YdFSBxH2Kz5qgLiI8B8KdVy3YBevqRHz/qWh72Yui3MUDEL3q44WPXw3M+fo1pZuQs4tOIBVVTaoiXEI/MxfhGDPsxsNZfoE1q66ro5aJim3XdoLFw72H+n23BaIXzbcOnz5mfPoTvYVz7KzUl5+FRxEuqkp9G/Ajia219thzg25abkRE/BpDc3pqvphHvRFys2weqvp+krbWKIX7nhDbzLOItiM8358pTwdirqpPFnMF2xLc1WvLyOwTAibpbmvHHcvttU57y5+XqNZrLe3lE/Pq8eUj2fXKfOe3pfOjzhJYtB/yll5SDFcSDiH+hRkH25+L+sdxKEAMZahrlSX8ukqMOWy/jXW2m6M9LDBc31B9LFuv6gVKg/0Szi3KAr1kGq1GMjU/aLbnq6/lRxc4XfJ98hTargX++DbMJBSiYMIe9Ck1YAxFkKEAG3xbYaKmDDgYyFK0UGYpfoWYXG+fAPPI6tJnNwb7ClP7IyF+D+bjOtCpkhz6CFrIa/I6sFtNl8auFXGMTP34sNwI/JhkgEtmDz14ySfaRcTIBInmKPE32kxyyE2Tv+thKbEVePDfW/byMM1Kmm0XdObS7oGD/MypMXFPXrCwOtoYjyyn7BV29/MZfsVzpLDdRtuIZnbpXzvlf+ev8MvYr/Gqk4H/kV/G3csdazLuyTMPsbFhzd1UabQbjFvDRmcWJxR3zcfHkVw9GfpbJmeev9F08WW8uDkaslwX6avlWGU6NRKz0g/SHtCy9J30o/ca9zX3Kfc19zn3BXQKRO8ud477hLnAfc1/G9mrzGlrfexZ5GLdn6ZZrrEohI2wVHhZywjbhUWEy8icMCGNCUdiBlq3r+xafL549HQ5jH+an+1y+LlYBifuxAvRN/lVVVOlwlCkdVm9NOL5BE4wkQ2SMlDZU97hX86EilU/lUmkQUztTE6mx1EEPh7OmdqBtAvv8HdWpbrJS6tJj3n0CWdM6busNzRV3S9KTYhqvNiqWmuroiKgYhshMjmhTh9ptWhsF7970j/SbMrsPE1suR5z7DMC+P/Hs+y7ijrQAlhyAgccjbhjPygfeBTjzhNqy28EdkUh8C+DU9+z2v/oyeH791OncxHOs5y2AtTc7nb/f73TWPkD/qwBnjX8BoJ98VVBg/m8AAAANSURBVAgdY2D43/AfAAUBAn8y755DAAAAAElFTkSuQmCC" }

    before do
      allow(DataUri).to receive(:new).and_return(data_uri)
    end
    let(:data_uri) {
      instance_double(
        "DataUri",
        :write_to_file => nil,
        :name => "/path/to/544c7a60c7e34728383b74b57.png",
      )
    }

    it "doesn't attempt to fetch the remote image" do
      store.call(src)

      expect(fetcher).not_to have_received(:call)
    end

    it "delegates to DataUri" do
      store.call(src)

      expect(DataUri).to have_received(:new).with(src)
    end

    it "writes the image data to disk" do
      store.call(src)

      expect(data_uri).to have_received(:write_to_file)
    end

    it "uses the name DataUri generates" do
      image_filename = store.call(src)

      expect(image_filename).to eq(data_uri.name)
    end
  end

  context "when the image URI is missing a scheme" do
    let(:origin) { "http://www.example.info" }
    let(:src) { "//www.example.com/art.jpg" }

    it "fetches the image using the origin URI's scheme" do
      store.call(src)

      expect(fetcher).to have_received(:call)
        .with("http:" + src, accept: supported_mime_types)
    end
  end

  context "when the image URI is missing the host" do
    context "and the URI is root-relative" do
      let(:origin) { "http://www.example.info" }
      let(:src) { "/art.jpg" }

      it "fetches the image using the origin URI's host and scheme" do
        store.call(src)

        expect(fetcher).to have_received(:call)
          .with(origin + src, accept: supported_mime_types)
      end
    end

    context "and the URI is relative" do
      let(:origin) { "http://www.example.info/gallery/index.html" }
      let(:src) { "art.jpg" }

      it "fetches the image relative to the 'origin'" do
        store.call(src)

        expect(fetcher).to have_received(:call).with(
          "http://www.example.info/gallery/art.jpg",
          accept: supported_mime_types,
        )
      end
    end
  end
end
