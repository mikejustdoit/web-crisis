require "text_node"

RSpec.describe TextNode do
  describe "drawing its text content" do
    subject(:text_node) { TextNode.new(content: text_content) }
    let(:text_content) { "Tweet of the week" }

    let(:drawing_visitor) { double(:drawing_visitor, :draw_text => nil) }

    before do
      text_node.draw(drawing_visitor)
    end

    it "supplies its text content to drawing visitor" do
      expect(drawing_visitor).to have_received(:draw_text).with(text_content)
    end
  end
end
