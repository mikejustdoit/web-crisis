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
end
