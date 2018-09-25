require "local_file_image_store"

RSpec.describe LocalFileImageStore do
  subject(:store) { LocalFileImageStore.new(origin: "/home/seppel/index.html") }

  before do
    stub_const("LOGGER", double(:logger, :call => nil))

    allow(File).to receive(:exist?).and_return(true)
  end

  context "when the URI contains the file:// scheme" do
    it "uses the file path from the URI" do
      image_filename = store["file:///home/seppel/art.jpg"]

      expect(image_filename).to eq("/home/seppel/art.jpg")
    end
  end

  context "without the file:// scheme" do
    it "uses the URI as the file path" do
      image_filename = store["/home/seppel/art.jpg"]

      expect(image_filename).to eq("/home/seppel/art.jpg")
    end
  end

  context "when the URI isn't even a string" do
    it "falls back to our placeholder image" do
      image_filename = store[nil]

      expect(image_filename).to eq(PLACEHOLDER_IMAGE)
    end
  end

  context "when no local file exists matching the URI" do
    before do
      allow(File).to receive(:exist?).and_return(false)
    end

    it "falls back to our placeholder image" do
      image_filename = store["https://www.example.com/art.jpg"]

      expect(image_filename).to eq(PLACEHOLDER_IMAGE)
    end

    it "logs the problem" do
      store["https://www.example.com/art.jpg"]

      expect(LOGGER).to have_received(:call)
        .with(/FileNotFound.*not found on disk/)
    end
  end

  describe "resolving relative file paths" do
    it "returns an absolute path" do
      image_filename = store["art.jpg"]

      expect(Pathname.new(image_filename)).to be_absolute
    end

    it "locates the file relative to the store's `origin` path" do
      image_filename = store["art.jpg"]

      expect(image_filename).to eq("/home/seppel/art.jpg")
    end
  end

  describe "handling file paths that aren't descendants of the origin" do
    context "when file path is absolute" do
      it "falls back to our placeholder image" do
        image_filename = store["/home/zaccharias/art.jpg"]

        expect(image_filename).to eq(PLACEHOLDER_IMAGE)
      end

      it "logs the problem" do
        store["/home/zaccharias/art.jpg"]

        expect(LOGGER).to have_received(:call)
          .with(/FileNotAccessible.*not a descendant of origin.*\/home\/seppel/)
      end
    end

    context "when file path is relative" do
      it "falls back to our placeholder image" do
        image_filename = store["../zaccharias/art.jpg"]

        expect(image_filename).to eq(PLACEHOLDER_IMAGE)
      end

      it "logs the problem" do
        store["../zaccharias/art.jpg"]

        expect(LOGGER).to have_received(:call)
          .with(/FileNotAccessible.*not a descendant of origin.*\/home\/seppel/)
      end
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

    it "delegates to DataUri" do
      store[src]

      expect(DataUri).to have_received(:new).with(src)
    end

    it "writes the image data to disk" do
      store[src]

      expect(data_uri).to have_received(:write_to_file)
    end

    it "uses the name DataUri generates" do
      image_filename = store[src]

      expect(image_filename).to eq(data_uri.name)
    end
  end
end
