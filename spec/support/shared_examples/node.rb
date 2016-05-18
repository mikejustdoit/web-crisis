RSpec.shared_examples "a node with a box" do
  it "allows reading box through getter" do
    expect(node.box).to eq(box)
  end

  it "exposes delegated getters for box's attributes" do
    expect(node.x).to eq(box.x)
    expect(node.y).to eq(box.y)
    expect(node.width).to eq(box.width)
    expect(node.height).to eq(box.height)
  end

  describe "creating a new node with new box attributes" do
    let(:new_box_attributes) { {:x => 10, :y => 10, :width => 50, :height => 50} }

    before do
      @returned_node = node.clone_with(new_box_attributes)
    end

    it "doesn't change the old node's attributes" do
      expect(node.x).to eq(box.x)
      expect(node.y).to eq(box.y)
      expect(node.width).to eq(box.width)
      expect(node.height).to eq(box.height)
    end

    it "returns a new node" do
      expect(@returned_node).not_to eq(node)
    end

    it "assigns the new node the specified attributes" do
      expect(@returned_node.x).to eq(new_box_attributes.fetch(:x))
      expect(@returned_node.y).to eq(new_box_attributes.fetch(:y))
      expect(@returned_node.width).to eq(new_box_attributes.fetch(:width))
      expect(@returned_node.height).to eq(new_box_attributes.fetch(:height))
    end
  end
end
