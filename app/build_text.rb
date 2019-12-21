require "text"
require "text_row"

class BuildText
  def call(box: Box.new, colour: :black, content:)
    Text.new(
      box: box,
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

  def zero_text_box(box)
    box.clone_with(x: 0, y: 0)
  end
end
