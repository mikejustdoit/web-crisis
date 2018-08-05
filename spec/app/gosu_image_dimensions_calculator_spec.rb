require "gosu_image_dimensions_calculator"

RSpec.describe GosuImageDimensionsCalculator do
  subject(:calculator) { GosuImageDimensionsCalculator.new }

  before do
    allow(Gosu::Image).to receive(:new).and_call_original
  end

  it "uses a Gosu::Image" do
    filename = "app/broken.png"

    calculator.call(filename)

    expect(Gosu::Image).to have_received(:new).with(filename)
  end

  it "returns width and height" do
    filename = "app/broken.png"

    width, height = calculator.call(filename)

    expect(width).to eq(100)
    expect(height).to eq(100)
  end
end
