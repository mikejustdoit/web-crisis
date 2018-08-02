require "element"
require "image"
require "image_fetcher"
require "inline_element"
require "support/gosu_adapter_stubs"
require "support/shared_examples/visitor"

RSpec.describe ImageFetcher do
  subject(:visitor) {
    ImageFetcher.new(
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
    allow(File).to receive(:open).and_yield(StringIO.new)
  end

  it_behaves_like "a visitor"

  context "when there are images" do
    let(:root) { InlineElement.new(Element.new(children: [image])) }
    let(:image) {
      InlineElement.new(Image.new(src: "https://www.example.com/art.jpg"))
    }

    it "fetches the image's asset" do
      visitor.call(root)

      expect(fetcher).to have_received(:call).with("https://www.example.com/art.jpg")
    end

    it "gives the image the filename of its asset on disk" do
      returned_root = visitor.call(root)

      returned_image = returned_root.children.first

      expect(returned_image.filename).not_to be_nil
      expect(returned_image.filename).not_to eq(PLACEHOLDER_IMAGE)
    end

    it "sets the new image dimensions" do
      returned_root = visitor.call(root)

      returned_image = returned_root.children.first

      expect(returned_image.width).to eq(image_width)
      expect(returned_image.height).to eq(image_height)
    end
  end
end
