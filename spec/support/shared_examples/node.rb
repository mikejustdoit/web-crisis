RSpec.shared_examples "a node with a box" do
  it "allows reading box through getter" do
    expect(node.box).to eq(box)
  end

  it "exposes delegated getters for box's attributes" do
    expect(node.x).to eq(x)
    expect(node.y).to eq(y)
    expect(node.width).to eq(width)
    expect(node.height).to eq(height)
  end

  describe "creating a new node with new box attributes" do
    let(:new_box) { Box.new(**new_box_attributes) }
    let(:new_box_attributes) { {:x => 10, :y => 10, :width => 50, :height => 50} }

    before do
      @returned_node = node.clone_with(new_box_attributes)
    end

    it "doesn't change the old node's box" do
      expect(node.box).to eq(box)
      expect(node.box).not_to eq(new_box)
    end

    it "returns a new node" do
      expect(@returned_node).not_to eq(node)
    end

    it "assigns the new node a new box with the specified attributes" do
      expect(@returned_node.box).to eq(new_box)
    end
  end
end
