RSpec.shared_examples "a visitor" do
  describe "callback interface" do
    it "supports Element nodes" do
      expect(visitor).to respond_to(:visit_element)
    end

    it "supports Text nodes" do
      expect(visitor).to respond_to(:visit_text)
    end
  end
end
