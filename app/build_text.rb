require "point"
require "text"
require "text_row"

class BuildText
  def call(box: Box.new, colour: :black, content:)
    Text.new(
      position: position_from_box(box),
      rows: [
        TextRow.new(
          box: zero_text_box(box),
          content: content,
        )
      ],
      colour: colour,
    )
  end

  private

  def position_from_box(box)
    Point.new(x: box.x, y: box.y)
  end

  def zero_text_box(box)
    box.clone_with(x: 0, y: 0)
  end
end
