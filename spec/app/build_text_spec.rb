require "box"
require "build_text"

RSpec.describe BuildText do
  subject(:service) { BuildText.new }

  let(:text_content) { "Tweet of the week" }
  let(:box) { Box.new(x: 0, y: 1, width: 2, height: 3) }

  it "assigns content" do
    text = service.call(box: box, content: text_content)

    expect(text.content).to eq(text_content)
  end

  it "assigns position" do
    text = service.call(box: box, content: text_content)

    expect(text.x).to eq(box.x)
    expect(text.y).to eq(box.y)
  end

  it "assigns dimensions" do
    text = service.call(box: box, content: text_content)

    expect(text.width).to eq(box.width)
    expect(text.height).to eq(box.height)
  end
end
