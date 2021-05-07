require "scroll_positioner"
require "support/shared_examples/visitor"

RSpec.describe ScrollPositioner do
  subject(:visitor) { ScrollPositioner.new(scroll_y: 1) }

  it_behaves_like "a visitor"

  it "applies the scroll offset to the whole tree" do
    root = Element.new(
      box: Box.new(y: 100),
      children: [
        Element.new(box: Box.new(y: 150)),
        Text.new(
          box: Box.new(y: 250),
          colour: :black,
          rows: [
            TextRow.new(box: Box.new(y: 250), content: "Infinite scroll"),
          ],
        ),
      ],
    )

    returned_root = visitor.call(root)

    expect(returned_root.y).to eq(99)
    expect(returned_root.children.first.y).to eq(149)

    expect(returned_root.children.last.y).to eq(249)
    expect(returned_root.children.last.rows.first.y).to eq(249)
  end
end
