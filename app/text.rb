require "forwardable"
require "point"
require "text_bounds"

class Text
  extend Forwardable

  def initialize(box:, colour:, rows:)
    @box = box
    @colour = colour
    @rows = rows
  end

  attr_reader :colour, :rows

  def_delegators :box, :x, :y, :width, :height, :right, :bottom

  def content
    rows.map(&:content).join(" ")
  end

  def clone_with(**attributes)
    Text.new(
      box: box.clone_with(**attributes),
      rows: attributes.fetch(:rows, rows),
      colour: attributes.fetch(:colour, colour),
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
    Point.new(x: x, y: y) + rows.last.next_available_point
  end

  def maximum_bounds
    TextBounds.new
  end

  private

  attr_reader :box
end
