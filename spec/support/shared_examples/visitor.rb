require "element"
require "node_types"
require "support/visitor_double"
require "text"

RSpec.shared_examples "a visitor" do
  describe "public interface" do
    let(:element) { Element.new(box: box, children: []) }
    let(:text) { Text.new(box: box, content: "Just passing.") }
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
    let(:root) { Element.new(children: children) }
    let(:children) { [Element.new(children: grandchildren), Element.new] }
    let(:grandchildren) { [Text.new(content: "ABC"), Element.new] }

    let(:all_nodes) { [root] + children + grandchildren }

    before do
      allow(visitor).to receive(:call).and_call_original

      visitor.call(root)
    end

    it "visits all nodes once in depth-first order" do
      expect(visitor).to have_received(:call).with(root).ordered
      expect(visitor).to have_received(:call).with(children.first).ordered
      expect(visitor).to have_received(:call).with(grandchildren.first).ordered
      expect(visitor).to have_received(:call).with(grandchildren.last).ordered
      expect(visitor).to have_received(:call).with(children.last).ordered
    end
  end
end

RSpec.shared_examples "a class-centric callable" do
  describe "handling unrecognised node types" do
    let(:weird_root) { double(:unrecognised_type_of_node) }

    it "complains about unrecognised node types" do
      expect {
        visitor.call(weird_root)
      }.to raise_error(UnrecognisedNodeType)
    end
  end
end
