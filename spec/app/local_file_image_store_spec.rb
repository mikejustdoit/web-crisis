require "local_file_image_store"
require "support/gosu_adapter_stubs"

RSpec.describe LocalFileImageStore do
  subject(:store) {
    LocalFileImageStore.new(
      image_dimensions_calculator: image_dimensions_calculator,
    )
  }
  let(:image_dimensions_calculator) {
    gosu_image_dimensions_calculator_stub(returns: [image_width, image_height])
  }
  let(:image_width) { 20 }
  let(:image_height) { 50 }

  before do
    stub_const("LOGGER", double(:logger, :call => nil))
  end

  context "when the URI contains the file:// scheme" do
    let(:src) { "file:///home/seppel/art.jpg" }

    it "uses the file path from the URI" do
      image_file = store[src]

      expect(image_file.name).to eq("/home/seppel/art.jpg")
    end

    it "returns a useful representation of the image on disk" do
      image_file = store[src]

      expect(image_file).to respond_to(:name)
      expect(image_file).to respond_to(:width)
      expect(image_file).to respond_to(:height)
    end
  end
end
