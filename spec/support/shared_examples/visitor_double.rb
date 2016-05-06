RSpec.shared_examples "a drawing visitor" do
  describe "callback interface" do
    it "supports Element nodes" do
      expect(drawing_visitor).to respond_to(:visit_element)
    end

    it "supports Text nodes" do
      expect(drawing_visitor).to respond_to(:visit_text)
    end
  end
end

RSpec.shared_examples "a layout visitor" do
  describe "callback interface" do
    it "supports Element nodes" do
      expect(layout_visitor).to respond_to(:visit_element)
    end

    it "supports Text nodes" do
      expect(layout_visitor).to respond_to(:visit_text)
    end
  end
end
