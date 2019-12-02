require "element"
require "image"
require "image_fetcher"
require "inline_element"
require "support/gosu_adapter_stubs"
require "support/shared_examples/visitor"

RSpec.describe ImageFetcher do
  subject(:visitor) {
    ImageFetcher.new(
      image_calculator: image_calculator,
      image_store: image_store,
    )
  }

  let(:image_calculator) {
    gosu_image_calculator_stub(returns: [image_width, image_height])
  }
  let(:image_width) { 20 }
  let(:image_height) { 50 }
  let(:image_filename) { "https---www-example-com-art-jpg-art.jpg" }
  let(:image_store) { double(:image_store, :[] => image_filename) }

  it_behaves_like "a visitor"

  context "when there are images" do
    let(:root) { InlineElement.new(Element.new(children: [image])) }
    let(:image) {
      InlineElement.new(Image.new(src: "https://www.example.com/art.jpg"))
    }

    it "fetches the image's asset from the store" do
      visitor.call(root)

      expect(image_store).to have_received(:[])
        .with("https://www.example.com/art.jpg")
    end

    it "gives the image the filename of its asset on disk" do
      returned_root = visitor.call(root)

      returned_image = returned_root.children.first

      expect(returned_image.filename).to eq(image_filename)
    end

    it "sets the new image dimensions" do
      returned_root = visitor.call(root)

      returned_image = returned_root.children.first

      expect(returned_image.width).to eq(image_width)
      expect(returned_image.height).to eq(image_height)
    end
  end
end
