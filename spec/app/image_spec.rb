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

  describe "cloning" do
    let(:node_specific_attribute) { :src }

    it_behaves_like "a clonable node"
  end

  describe "working with node's position and dimensions" do
    let(:box) { Box.new(x: 0, y: 1, width: 2, height: 3) }

    it_behaves_like "a node with position and dimensions"
  end
end
