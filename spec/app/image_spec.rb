require "image"
require "support/shared_examples/node"

RSpec.describe Image do
  subject(:node) { Image.new(src: src) }
  let(:src) { "https://www.example.com/art.jpg" }

  it "has a #src" do
    expect(node.src).to eq(src)
  end

  describe "cloning" do
    let(:node_specific_attribute) { :src }

    it_behaves_like "a clonable node"
  end
end
