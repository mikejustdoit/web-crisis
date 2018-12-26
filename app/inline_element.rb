require "point"

class InlineElement < SimpleDelegator
  def inspect
    "InlineElement<#{__getobj__}>"
  end

  def to_s
    inspect
  end

  def clone_with(**attributes)
    InlineElement.new(
      __getobj__.clone_with(**attributes),
    )
  end

  def clone_with_children(new_children)
    InlineElement.new(
      __getobj__.clone_with_children(new_children),
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
    if respond_to?(:children) && children.any?
      point = children.last.next_available_point
      Point.new(x: x + point.x, y: y + point.y)
    else
      Point.new(x: right, y: y)
    end
  end
end
