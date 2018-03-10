require "text"
require "text_row"

class BuildText
  def call(box: Box.new, content:)
    Text.new(
      box: box,
      rows: [
        TextRow.new(
          box: zero_text_box(box),
          content: content,
        )
      ]
    )
  end

  def zero_text_box(box)
    box.clone_with(x: 0, y: 0)
  end
end
