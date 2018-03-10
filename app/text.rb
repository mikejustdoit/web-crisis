require "box"
require "build_text"
require "forwardable"
require "point"

class Text
  extend Forwardable

  def initialize(box: Box.new, rows:)
    @box = box
    @rows = rows
  end

  attr_reader :rows

  def_delegators :box, :x, :y, :width, :height, :right, :bottom

  def content
    rows.map(&:content).join
  end

  def clone_with(**attributes)
    Text.new(
      box: box.clone_with(**attributes),
      rows: attributes.fetch(:rows, rows),
    )
  end

  def +(other_text_node)
    BuildText.new.call(
      box: box.clone_with(
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
    Point.new(x: right, y: y)
  end

  private

  attr_reader :box
end
