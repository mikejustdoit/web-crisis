require "image_store"
require "support/gosu_adapter_stubs"

RSpec.describe ImageStore do
  subject(:store) {
    ImageStore.new(
      fetcher: fetcher,
      image_dimensions_calculator: image_dimensions_calculator,
    )
  }
  let(:fetcher) { double(:fetcher, :call => "ABCIMAGECONTENTS") }
  let(:image_dimensions_calculator) {
    gosu_image_dimensions_calculator_stub(returns: [image_width, image_height])
  }
  let(:image_width) { 20 }
  let(:image_height) { 50 }

  before do
    allow(File).to receive(:open).and_yield(file)
    allow(file).to receive(:print).and_call_original
  end
  let(:file) { StringIO.new }

  context "when we have a matching file on disk" do
    before do
      allow(File).to receive(:exist?).and_return(true)
    end

    let(:src) { "https://www.example.com/art.jpg" }

    it "doesn't attempt to fetch the remote image" do
      store[src]

      expect(fetcher).not_to have_received(:call)
    end

    it "doesn't attempt to write to disk" do
      store[src]

      expect(File).not_to have_received(:open)
    end

    it "returns a useful representation of the image on disk" do
      image_file = store[src]

      expect(image_file).to respond_to(:name)
      expect(image_file).to respond_to(:width)
      expect(image_file).to respond_to(:height)
    end
  end

  context "when there is no matching file on disk" do
    before do
      allow(File).to receive(:exist?).and_return(false)
    end

    let(:src) { "https://www.example.com/art.jpg" }

    it "fetches the image" do
      store[src]

      expect(fetcher).to have_received(:call).with(src)
    end

    it "writes the image to disk" do
      store[src]

      expect(file).to have_received(:print)
    end

    it "returns a useful representation of the image on disk" do
      image_file = store[src]

      expect(image_file).to respond_to(:name)
      expect(image_file).to respond_to(:width)
      expect(image_file).to respond_to(:height)
    end
  end
end
