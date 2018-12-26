require "text_bounds"

class NodeWithinParent < SimpleDelegator
  def initialize(node, parent)
    @node = node
    @parent = parent

    super(node)
  end

  def inspect
    "NodeWithinParent<#{node}, #{parent}>"
  end

  def to_s
    inspect
  end

  def maximum_bounds
    return node.maximum_bounds if node.maximum_bounds.defined?

    parents_bounds_relative_to_node
  end

  def clone_with(**attributes)
    NodeWithinParent.new(
      node.clone_with(**attributes),
      parent,
    )
  end

  def clone_with_children(new_children)
    NodeWithinParent.new(
      node.clone_with_children(new_children),
      parent,
    )
  end

  def position_after(preceding_node)
    NodeWithinParent.new(
      node.position_after(preceding_node),
      parent,
    )
  end

  private

  attr_reader :node, :parent

  def parents_bounds_relative_to_node
    TextBounds.new(
      x: parents_maximum_bounds.x - node.x,
      width: parents_maximum_bounds.width,
    )
  end

  def parents_maximum_bounds
    @parents_maximum_bounds ||= parent.maximum_bounds
  end
end
