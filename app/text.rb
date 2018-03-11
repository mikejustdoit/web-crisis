require "box"
require "build_text"
require "forwardable"

class Text
  extend Forwardable

  def initialize(position:, rows:)
    @position = position
    @rows = rows
  end

  attr_reader :rows

  def_delegators :position, :x, :y

  def width
    rows.map(&:right).max
  end

  def height
    rows.map(&:bottom).max
  end

  def right
    x + width
  end

  def bottom
    y + height
  end

  def content
    rows.map(&:content).join
  end

  def clone_with(**attributes)
    Text.new(
      position: position.clone_with(**attributes),
      rows: attributes.fetch(:rows, rows),
    )
  end

  def +(other_text_node)
    BuildText.new.call(
      box: Box.new(
        x: x,
        y: y,
        width: width + other_text_node.width,
        height: [height, other_text_node.height].max,
      ),
      content: content + other_text_node.content,
    )
  end

  def position_after(preceding_node)
    point = preceding_node.next_available_point
    clone_with(
      x: point.x,
      y: point.y,
    )
  end

  def next_available_point
    position + rows.last.next_available_point
  end

  private

  attr_reader :position
end
