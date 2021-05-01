require "box"
require "build_text"
require "element"
require "image"
require "inspector"
require "link"
require "point"
require "text_search"

RSpec.describe Inspector do
  subject(:inspector) { Inspector.new(root_node) }

  describe "#bounding_boxes_for_first" do
    let(:root_node) { double(:render_tree) }
    let(:text_search) {
      instance_double(TextSearch, bounding_boxes_for_first: boxes)
    }

    before do
      allow(TextSearch).to receive(:new).and_return(text_search)
    end

    context "when the tree contains the search text" do
      let(:boxes) { [double(:box), double(:box)] }

      it "returns the bounding box of that node" do
        expect(
          inspector.bounding_boxes_for_first("existing text")
        ).to eq(boxes)
      end
    end

    context "when the tree does not contain the search text" do
      let(:boxes) { [] }

      it "complains" do
        expect {
          inspector.bounding_boxes_for_first("non-existent text")
        }.to raise_error(Inspector::NotEnoughMatchesFound)
      end
    end
  end

  describe "finding a single image node by `src`" do
    context "when there is one on the page" do
      let(:root_node) { Element.new(children: [image]) }
      let(:image) { Image.new(src: "https://www.example.com/art.jpg") }

      it "returns it" do
        expect(
          inspector.find_single_image("https://www.example.com/art.jpg")
        ).to eq(image)
      end
    end

    context "when there are none" do
      let(:root_node) { Element.new(children: []) }

      it "complains" do
        expect {
          inspector.find_single_image("https://www.example.com/art.jpg")
        }.to raise_error(Inspector::NotEnoughMatchesFound)
      end
    end

    context "when there are multiple matches" do
      let(:root_node) {
        Element.new(
          children: [
            Image.new(src: "https://www.example.com/art.jpg"),
            Image.new(src: "https://www.example.com/art.jpg"),
          ]
        )
      }

      it "complains" do
        expect {
          inspector.find_single_image("https://www.example.com/art.jpg")
        }.to raise_error(Inspector::TooManyMatchesFound)
      end
    end
  end

  describe "finding a single <a> by `href`" do
    context "when there is one on the page" do
      let(:root_node) { Element.new(children: [link]) }
      let(:link) { Link.new(Element.new, href: "https://www.example.com/news.html") }

      it "returns it" do
        expect(
          inspector.find_single_link("https://www.example.com/news.html")
        ).to eq(link)
      end
    end

    context "when there are none" do
      let(:root_node) { Element.new(children: []) }

      it "complains" do
        expect {
          inspector.find_single_link("https://www.example.com/news.html")
        }.to raise_error(Inspector::NotEnoughMatchesFound)
      end
    end

    context "when there are multiple matches" do
      let(:root_node) {
        Element.new(
          children: [
            Link.new(Element.new, href: "https://www.example.com/news.html"),
            Link.new(Element.new, href: "https://www.example.com/news.html"),
          ]
        )
      }

      it "complains" do
        expect {
          inspector.find_single_link("https://www.example.com/news.html")
        }.to raise_error(Inspector::TooManyMatchesFound)
      end
    end
  end

  describe "finding an element in the viewport based on (x, y) coordinates" do
    context "when the coordinates are outside of the viewport" do
      let(:root_node) {
        Element.new(box: Box.new(x: 0, y: 0, width: 10, height: 10))
      }

      it "returns nil" do
        expect(
          inspector.find_element_at(Point.new(x: 9000, y: 9000))
        ).to be_nil
      end
    end

    context "when there's only one element at the coordinates" do
      let(:root_node) {
        Element.new(box: Box.new(x: 0, y: 0, width: 10, height: 10))
      }

      it "returns it" do
        expect(
          inspector.find_element_at(Point.new(x: 5, y: 5))
        ).to eq(root_node)
      end
    end

    context "when there are nested elements at the coordinates" do
      let(:root_node) {
        Element.new(
          box: Box.new(x: 0, y: 0, width: 100, height: 100),
          children: [
            Element.new(
              box: Box.new(x: 0, y: 0, width: 10, height: 10),
            ),
          ],
        )
      }

      it "returns the most specific one" do
        expect(
          inspector.find_element_at(Point.new(x: 5, y: 5))
        ).to eq(root_node.children.first)
      end
    end

    context "when there's text at the coordinates" do
      let(:root_node) {
        Element.new(
          box: Box.new(x: 0, y: 0, width: 100, height: 100),
          children: [
            Element.new(
              box: Box.new(x: 0, y: 0, width: 10, height: 10),
              children: [BuildText.new.call(content: "Now you see me")],
            ),
          ],
        )
      }

      it "returns the text node's immediate parent element" do
        expect(
          inspector.find_element_at(Point.new(x: 5, y: 5))
        ).to eq(root_node.children.first)
      end
    end
  end
end
