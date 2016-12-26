require "node_types"

class SubsequentChildPositioner
  def call(node, preceding_sibling_node:)
    case node
    when *INLINE_NODES
      case preceding_sibling_node
      when *INLINE_NODES
        position_inline(node, preceding_sibling_node: preceding_sibling_node)
      else
        position_block_level(node, preceding_sibling_node: preceding_sibling_node)
      end
    else
      position_block_level(node, preceding_sibling_node: preceding_sibling_node)
    end
  end

  private

  def position_block_level(node, preceding_sibling_node:)
    node.clone_with(
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
