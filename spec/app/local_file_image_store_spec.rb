require "local_file_image_store"

RSpec.describe LocalFileImageStore do
  subject(:store) { LocalFileImageStore.new }

  before do
    stub_const("LOGGER", double(:logger, :call => nil))
  end

  context "when the URI contains the file:// scheme" do
    let(:src) { "file:///home/seppel/art.jpg" }

    it "uses the file path from the URI" do
      image_filename = store[src]

      expect(image_filename).to eq("/home/seppel/art.jpg")
    end
  end
end
