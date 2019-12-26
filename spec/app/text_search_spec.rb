require "box"
require "build_text"
require "element"
require "inline_element"
require "link"
require "text_search"

RSpec.describe TextSearch do
  describe "requesting bounding boxes for a substring" do
    subject(:search) { TextSearch.new(tree) }

    let(:tree) {
      Element.new(
        children: [
          BuildText.new.call(
            content: "On the 28th October 1991. Tim Berners-Lee started the ",
          ),
          InlineElement.new(
            Link.new(
              Element.new(
                children: [
                  BuildText.new.call(content: "World Wide Web mailing list"),
                ],
              ),
              href: "https://lists.w3.org/Archives/Public/www-talk/1991SepOct/0001.html",
            )
          ),
          BuildText.new.call(
            content: ", which has in one form or another run ever since, though it's rarely posted to today.",
          ),
        ],
      )
    }

    context "when there's no match" do
      it "returns an empty array" do
        expect(search.bounding_boxes_for_first("non-existent text")).to eq([])
      end
    end

    context "when there's a match contained entirely in a single TextRow" do
      it "returns an array of that TextRow" do
        boxes = search.bounding_boxes_for_first("October")

        expect(boxes.size).to eq(1)
        expect(boxes.first).to be_a(Box)
      end

      it "doesn't get it wrong even if the match is right upto the TextRow's edge" do
        boxes = search.bounding_boxes_for_first("World Wide Web mailing list")

        expect(boxes.size).to eq(1)
        expect(boxes.first).to be_a(Box)
      end
    end

    context "when there's a match that spans multiple TextRows" do
      it "returns an array of those TextRows" do
        boxes = search.bounding_boxes_for_first("mailing list, which has")

        expect(boxes.size).to eq(2)
        expect(boxes).to all(be_a(Box))
      end
    end

    context "when the search term appears multiple times" do
      it "only returns the first match until we decide to support more" do
        boxes = search.bounding_boxes_for_first("th")

        expect(boxes.size).to eq(1)
        expect(boxes.first).to be_a(Box)
      end
    end
  end
end
