require "build_text"
require "support/element_helpers"
require "support/visitor_double"
require "text"

RSpec.shared_examples "a visitor" do
  describe "public interface" do
    let(:element) { build_inline_element(box: box, children: []) }
    let(:text) { BuildText.new.call(box: box, content: "Just passing.") }
    let(:box) { Box.new(x: 0, y: 1, width: 2, height: 3) }

    it "supports Element nodes" do
      expect(
        visitor.call(element)
      ).not_to be_nil
    end

    it "supports Text nodes" do
      expect(
        visitor.call(text)
      ).not_to be_nil
    end
  end
end

RSpec.shared_examples "a depth-first tree traverser" do
  describe "traversal" do
    let(:root) { build_block_level_element(children: children) }
    let(:children) {
      [build_inline_element(children: grandchildren), build_inline_element]
    }
    let(:grandchildren) {
      [
        BuildText.new.call(
          box: Box.new(x: 0, y: 0, width: 100, height: 100),
          content: "ABC",
        ),
        build_inline_element,
      ]
    }

    let(:all_nodes) { [root] + children + grandchildren }

    before do
      allow(visitor).to receive(:call).and_call_original

      visitor.call(root)
    end

    it "visits all nodes once in depth-first order" do
      expect(visitor).to have_received(:call).with(root, any_args).ordered
      expect(visitor).to have_received(:call).with(children.first, any_args).ordered
      expect(visitor).to have_received(:call).with(grandchildren.first, any_args).ordered
      expect(visitor).to have_received(:call).with(grandchildren.last, any_args).ordered
      expect(visitor).to have_received(:call).with(children.last, any_args).ordered
    end
  end
end
