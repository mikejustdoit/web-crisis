require "point"

class InlineElement < SimpleDelegator
  def clone_with(**attributes)
    InlineElement.new(
      __getobj__.clone_with(**attributes),
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
    if children.any?
      point = children.last.next_available_point
      Point.new(x: x + point.x, y: y + point.y)
    else
      Point.new(x: right, y: y)
    end
  end
end
