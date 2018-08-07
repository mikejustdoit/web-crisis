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

  context "when Gosu::Image isn't happy" do
    before do
      allow(Gosu::Image).to receive(:new).and_raise(
        RuntimeError.new("Cannot load image: unknown image type")
      )
    end

    filename = "app/broken.png"

    it "raises its own error" do
      expect { calculator.call(filename) }.to raise_error(
        GosuImageDimensionsCalculator::Error
      )
    end

    it "surfaces the original error message" do
      expect { calculator.call(filename) }.to raise_error(/unknown image type/)
    end

    it "also includes the filename" do
      expect { calculator.call(filename) }.to raise_error(/#{filename}/)
    end
  end
end
