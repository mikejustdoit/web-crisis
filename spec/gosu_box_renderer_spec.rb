require "box"
require "gosu_box_renderer"

RSpec.describe GosuBoxRenderer do
  subject(:gosu_box_renderer) { GosuBoxRenderer.new(viewport) }

  before do
    allow(Gosu).to receive(:draw_quad).and_return(nil)
  end

  describe "adapting Gosu::Font" do
    let(:viewport) { Box.new(x: 0, y: 0, width: 200, height: 100) }

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

  describe "translating for window" do
    let(:viewport) {
      Box.new(
        x: viewport_x,
        y: viewport_y,
        width: viewport_width,
        height: viewport_height,
      )
    }
    let(:viewport_x) { 10 }
    let(:viewport_y) { 10 }
    let(:viewport_width) { 200 }
    let(:viewport_height) { 100 }

    describe "#call" do
      let(:x) { 10 }
      let(:y) { 0 }
      let(:width) { 100 }
      let(:height) { 50 }

      before do
        gosu_box_renderer.call(x, y, width, height)
      end

      let(:x_plus_viewport_x) { x + viewport_x }
      let(:y_plus_viewport_y) { y + viewport_y }

      it "translates the viewport-world position to a window position" do
        expect(Gosu).to have_received(:draw_quad).with(
          x_plus_viewport_x,
          y_plus_viewport_y,
          any_args,
        )
      end
    end
  end
end
