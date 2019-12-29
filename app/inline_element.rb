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

  def position_after(preceding_node)
    point = preceding_node.next_available_point
    clone_with(
      x: point.x,
      y: point.y,
    )
  end

  def next_available_point
    if respond_to?(:children) && children.any?
      Point.from(self) + children.last.next_available_point
    else
      Point.new(x: right, y: y)
    end
  end
end
