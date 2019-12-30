RSpec.shared_examples "a valid node decorator" do
  describe "cloning" do
    it "has a #clone_with" do
      expect(node).to respond_to(:clone_with)
    end

    it "returns a clone of itself" do
      expect(node.clone_with({})).to be_a(node.class)
    end
  end

  it "exposes its underlying node's attributes too" do
    expect(node.width).to eq(internal_node.width)
  end
end
