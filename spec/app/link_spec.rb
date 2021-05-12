require "box"
require "element"
require "link"
require "support/shared_examples/node_decorator"

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

  describe "clickability" do
    context "with no href" do
      it "is not clickable" do
        node = Link.new(Element.new, href: nil)

        expect(node).not_to be_clickable
      end
    end

    context "with an empty href" do
      it "is not clickable" do
        node = Link.new(Element.new, href: "")

        expect(node).not_to be_clickable
      end
    end

    context "with a non-empty href" do
      it "is clickable" do
        node = Link.new(Element.new, href: "/help")

        expect(node).to be_clickable
      end
    end
  end

  describe "decorating" do
    let(:internal_node) { element }

    it_behaves_like "a valid node decorator"
  end

  describe "cloning" do
    let(:returned_node) { node.clone_with(**{}) }

    let(:node_specific_attribute) { :href }

    it_behaves_like "a clonable node"

    it "returns a Link" do
      expect(returned_node).to be_a(Link)
    end
  end
end
