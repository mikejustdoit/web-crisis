RSpec.shared_examples "a node with position and dimensions" do
  it "exposes delegated getters for box's attributes" do
    expect(node.x).to eq(box.x)
    expect(node.y).to eq(box.y)
    expect(node.width).to eq(box.width)
    expect(node.height).to eq(box.height)
    expect(node.right).to eq(box.right)
    expect(node.bottom).to eq(box.bottom)
  end

  describe "creating a new node with new attributes" do
    let(:new_attributes) { {:x => 10, :y => 10, :width => 50, :height => 50} }

    let(:clone_of_node) { node.clone_with(**new_attributes) }

    it "doesn't change the old node's attributes" do
      expect(node.x).to eq(box.x)
      expect(node.y).to eq(box.y)
      expect(node.width).to eq(box.width)
      expect(node.height).to eq(box.height)
    end

    it "assigns the new node the specified attributes" do
      expect(clone_of_node.x).to eq(new_attributes.fetch(:x))
      expect(clone_of_node.y).to eq(new_attributes.fetch(:y))
      expect(clone_of_node.width).to eq(new_attributes.fetch(:width))
      expect(clone_of_node.height).to eq(new_attributes.fetch(:height))
    end
  end
end

RSpec.shared_examples "a clonable node" do
  context "without changing its attributes" do
    let(:clone_of_node) { node.clone_with(**{}) }

    it "returns a new node" do
      expect(clone_of_node).not_to eql(node)
    end

    it "copies over original node's attributes" do
      expect(
        clone_of_node.send(node_specific_attribute)
      ).to match(
        node.send(node_specific_attribute)
      )
    end
  end

  context "when changing an attribute" do
    let(:clone_of_node) {
      node.clone_with(
        **{ node_specific_attribute => new_value }
      )
    }
    let(:new_value) { "ALL NEW VALUE" }

    it "returns a new node" do
      expect(clone_of_node).not_to eq(node)
    end

    it "doesn't change the old node's attribute" do
      expect(
        node.send(node_specific_attribute)
      ).not_to match(new_value)
    end

    it "assigns the new node the specified attribute" do
      expect(
        clone_of_node.send(node_specific_attribute)
      ).to match(new_value)
    end
  end
end
