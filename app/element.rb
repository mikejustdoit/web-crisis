require "box"
require "children_measurer"
require "forwardable"
require "text_bounds"

class Element
  extend Forwardable

  def initialize(box: Box.new, children: [])
    @box = box
    @children = children.dup
  end

  def_delegators :box, :x, :y, :width, :height, :right, :bottom

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

  def clone_with_children(new_children)
    inner_width, inner_height = measure_children_dimensions(new_children)
    x_offset, y_offset = minimum_children_position_offset(new_children)

    clone_with(
      children: new_children,
      x: x + x_offset,
      y: y + y_offset,
      width: inner_width,
      height: inner_height,
    )
  end

  def maximum_bounds
    TextBounds.new(x: x, width: width)
  end

  private

  attr_reader :box

  def measure_children_dimensions(children)
    ChildrenMeasurer.new.call(children)
  end

  def minimum_children_position_offset(children)
    return children.map(&:x).min || 0, children.map(&:y).min || 0
  end
end
