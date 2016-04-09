require "text_node"

RSpec.describe TextNode do
  subject(:text_node) { TextNode.new(content: text_content) }
  let(:text_content) { "Tweet of the week" }

  describe "drawing its text content" do
    let(:drawing_visitor) { double(:drawing_visitor, :draw_text => nil) }

    before do
      text_node.draw(drawing_visitor)
    end

    it "supplies its text content to drawing visitor" do
      expect(drawing_visitor).to have_received(:draw_text).with(text_content)
    end
  end

  describe "quacking like a Node" do
    it "has a #map_children method" do
      expect(text_node).to respond_to(:map_children)
    end

    it "returns an empty array" do
      expect(
        text_node.map_children(->(child) { :something })
      ).to eq([])
    end
  end
end
