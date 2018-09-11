require "forwardable"
require "text_bounds"

class Text
  extend Forwardable

  def initialize(colour:, position:, rows:)
    @colour = colour
    @position = position
    @rows = rows
  end

  attr_reader :colour, :rows

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
    rows.map(&:content).join(" ")
  end

  def clone_with(**attributes)
    Text.new(
      position: position.clone_with(**attributes),
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
    position + rows.last.next_available_point
  end

  def maximum_bounds
    TextBounds.new
  end

  private

  attr_reader :position
end
