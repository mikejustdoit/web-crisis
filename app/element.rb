require "box"
require "forwardable"
require "text_bounds"

class Element
  extend Forwardable

  def initialize(box: Box.new, children: [])
    @box = box
    @children = children.dup
  end

  def_delegators :box, :x, :y, :width, :height, :right, :bottom, :overlaps?

  def children
    @children.dup
  end

  def content
    children.map(&:content).join
  end

  def clone_with(**attributes)
    Element.new(
      box: box.clone_with(**attributes),
      children: attributes.fetch(:children, children),
    )
  end

  def maximum_bounds
    TextBounds.new(x: x, width: width)
  end

  def clickable?
    false
  end

  private

  attr_reader :box
end
