require "node_types"

class ChildrenPositioner
  def call(node)
    new_children = node.children.first(1)
      .map { |first_child|
        position_first_child(first_child)
      }

    new_children = node.children.drop(1)
      .inject(new_children) { |preceding_children, child|
        preceding_children + [
          position_subsequent_child(
            child,
            preceding_sibling_node: preceding_children.last,
          )
        ]
      }

    new_children
  end

  private

  def position_first_child(first_child)
    first_child.clone_with(
      x: 0,
      y: 0,
    )
  end

  def position_subsequent_child(subsequent_child, preceding_sibling_node:)
    case subsequent_child
    when *INLINE_NODES
      case preceding_sibling_node
      when *INLINE_NODES
        position_inline(subsequent_child, preceding_sibling_node: preceding_sibling_node)
      else
        position_block_level(subsequent_child, preceding_sibling_node: preceding_sibling_node)
      end
    else
      position_block_level(subsequent_child, preceding_sibling_node: preceding_sibling_node)
    end
  end

  def position_block_level(node, preceding_sibling_node:)
    node.clone_with(
      x: preceding_sibling_node.x,
      y: preceding_sibling_node.bottom,
    )
  end

  def position_inline(node, preceding_sibling_node:)
    node.clone_with(
      x: preceding_sibling_node.right,
      y: preceding_sibling_node.y,
    )
  end
end
