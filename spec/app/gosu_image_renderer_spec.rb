require "box"
require "gosu_image_renderer"

RSpec.describe GosuImageRenderer do
  subject(:gosu_image_renderer) { GosuImageRenderer.new(viewport) }

  before do
    allow(Gosu::Image).to receive(:new).and_return(gosu_image)
    allow(gosu_image).to receive(:draw).and_return(nil)
  end
  let(:gosu_image) { Gosu::Image.new("app/broken.png") }

  describe "delegating to Gosu" do
    let(:viewport) { Box.new(x: 0, y: 0, width: 200, height: 100) }

    describe "#call" do
      let(:x) { 10 }
      let(:y) { 0 }

      it "delegates drawing the image to Gosu::Image" do
        gosu_image_renderer.call("app/broken.png", x, y)

        expect(Gosu::Image).to have_received(:new).with("app/broken.png")
        expect(gosu_image).to have_received(:draw).with(x, y, any_args)
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

      it "translates the viewport-world position to a window position" do
        x_plus_viewport_x = x + viewport_x
        y_plus_viewport_y = y + viewport_y

        gosu_image_renderer.call("app/broken.png", x, y)

        expect(gosu_image).to have_received(:draw).with(
          x_plus_viewport_x,
          y_plus_viewport_y,
          any_args,
        )
      end
    end
  end
end
