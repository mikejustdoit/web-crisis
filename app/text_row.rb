require "box"
require "forwardable"
require "point"

class TextRow
  extend Forwardable

  def initialize(box: Box.new, content:)
    @box = box
    @content = content
  end

  attr_reader :content

  def_delegators :box, :x, :y, :width, :height, :right, :bottom

  def clone_with(**attributes)
    TextRow.new(
      box: box.clone_with(**attributes),
      content: attributes.fetch(:content, content),
    )
  end

  def +(other_text_row)
    clone_with(
      content: content + other_text_row.content,
      width: width + other_text_row.width,
      height: [height, other_text_row.height].max,
    )
  end

  def next_available_point
    Point.new(x: right, y: y)
  end

  def ==(other_row)
    content == other_row.content &&
      x == other_row.x &&
      y == other_row.y &&
      width == other_row.width &&
      height == other_row.height
  end

  private

  attr_reader :box
end
