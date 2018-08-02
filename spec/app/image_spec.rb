require "image"

RSpec.describe Image do
  subject(:node) { Image.new(src: src) }
  let(:src) { "https://www.example.com/art.jpg" }

  it "has a #src" do
    expect(node.src).to eq(src)
  end
end
