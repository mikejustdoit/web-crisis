require "no_preceding_sibling"

RSpec.describe NoPrecedingSibling do
  describe "communicating the next available position for subsequent nodes" do
    subject(:node) { NoPrecedingSibling.new }

    it "returns a point" do
      expect(node.next_available_point).to respond_to(:x)
      expect(node.next_available_point).to respond_to(:y)
    end

    context "when requested by an inline node" do
      it "suggests the caller's parent's left, top edge as the next available position" do
        expect(node.next_available_point.x).to eq(0)
        expect(node.next_available_point.y).to eq(0)
      end
    end

    context "when requested by a block level node" do
      it "presents its bottommost point as the caller's parent's top edge" do
        expect(node.bottom).to eq(0)
      end
    end
  end
end
