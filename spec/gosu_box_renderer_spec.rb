require "gosu_box_renderer"

RSpec.describe GosuBoxRenderer do
  describe "adapting Gosu::Font" do
    subject(:gosu_box_renderer) { GosuBoxRenderer.new }

    before do
      allow(Gosu).to receive(:draw_quad).and_return(nil)
    end

    describe "#call" do
      let(:x) { 10 }
      let(:y) { 0 }
      let(:width) { 100 }
      let(:height) { 50 }

      before do
        gosu_box_renderer.call(x, y, width, height)
      end

      it "draws the box with Gosu" do
        expect(Gosu).to have_received(:draw_quad).with(x, y, any_args)
      end
    end
  end
end
