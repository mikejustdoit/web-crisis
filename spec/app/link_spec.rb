require "box"
require "element"
require "link"

RSpec.describe Link do
  subject(:node) { Link.new(element, href: "/faq") }
  let(:element) {
    Element.new(
      box: Box.new(x: 0, y: 1, width: 2, height: 3),
      children: [],
    )
  }

  it "has an href" do
    expect(node.href).to eq("/faq")
  end

  it "exposes its underlying element's attributes too" do
    expect(node.width).to eq(element.width)
  end

  describe "cloning" do
    let(:returned_node) { node.clone_with({}) }

    let(:node_specific_attribute) { :href }

    it_behaves_like "a clonable node"

    it "returns a Link" do
      expect(returned_node).to be_a(Link)
    end
  end
end