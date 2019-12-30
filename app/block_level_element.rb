require "point"

class BlockLevelElement < SimpleDelegator
  def inspect
    "BlockLevelElement<#{__getobj__}>"
  end

  def to_s
    inspect
  end

  def clone_with(**attributes)
    BlockLevelElement.new(
      __getobj__.clone_with(**attributes),
    )
  end

  def the_position_after(preceding_node)
    Point.new(x: 0, y: preceding_node.bottom)
  end

  def next_available_point
    Point.new(x: x, y: bottom)
  end
end
