RSpec.shared_examples "a drawing visitor" do
  describe "callback interface" do
    it "supports Element nodes" do
      expect(drawing_visitor).to respond_to(:draw_box)
    end

    it "supports Text nodes" do
      expect(drawing_visitor).to respond_to(:draw_text)
    end
  end
end

RSpec.shared_examples "a layout visitor" do
  describe "callback interface" do
    it "supports Element nodes" do
      expect(layout_visitor).to respond_to(:layout_node)
    end

    it "supports Text nodes" do
      expect(layout_visitor).to respond_to(:layout_text_node)
    end
  end
end
