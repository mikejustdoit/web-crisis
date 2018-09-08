require "local_file_image_store"

RSpec.describe LocalFileImageStore do
  subject(:store) { LocalFileImageStore.new(origin: "/home/seppel/index.html") }

  before do
    stub_const("LOGGER", double(:logger, :call => nil))
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
end
