require "box"
require "image"
require "support/shared_examples/node"

RSpec.describe Image do
  subject(:node) { Image.new(box: box, src: src) }
  let(:box) { Box.new(x: 0, y: 1, width: 2, height: 3) }
  let(:src) { "https://www.example.com/art.jpg" }

  it "has a #src" do
    expect(node.src).to eq(src)
  end

  it "has #content for compatibility with other nodes" do
    expect(node.content).to eq("")
  end

  describe "the filename of the image on disk" do
    context "when it has a file" do
      subject(:node) {
        Image.new(filename: filename, src: "https://www.example.com/art.jpg")
      }
      let(:filename) { "34jl3h543jlh-art.jpg" }

      it "is retrievable with #filename" do
        expect(node.filename).to eq(filename)
      end
    end

    context "when it hasn't had a file explicitly set" do
      subject(:node) { Image.new(src: "https://www.example.com/art.jpg") }

      it "returns a placeholder image from #filename" do
        expect(node.filename).not_to be_nil
      end
    end
  end

  describe "cloning" do
    let(:node_specific_attribute) { :src }

    it_behaves_like "a clonable node"
  end

  describe "working with node's position and dimensions" do
    let(:box) { Box.new(x: 0, y: 1, width: 2, height: 3) }

    it_behaves_like "a node with position and dimensions"
  end
end
