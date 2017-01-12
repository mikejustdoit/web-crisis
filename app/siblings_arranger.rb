require "node_types"

class SiblingsArranger
  def call(nodes)
    new_nodes = nodes.first(1)
      .map { |first_node|
        position_first_node(first_node)
      }

    new_nodes = nodes.drop(1)
      .inject(new_nodes) { |preceding_nodes, node|
        preceding_nodes + [
          position_a_subsequent_node(
            node,
            preceding_sibling: preceding_nodes.last,
          )
        ]
      }

    new_nodes
  end

  private

  def position_first_node(first_node)
    first_node.clone_with(
      x: 0,
      y: 0,
    )
  end

  def position_a_subsequent_node(node, preceding_sibling:)
    case node
    when *INLINE_NODES
      case preceding_sibling
      when *INLINE_NODES
        position_inline(node, preceding_sibling: preceding_sibling)
      else
        position_block_level(node, preceding_sibling: preceding_sibling)
      end
    else
      position_block_level(node, preceding_sibling: preceding_sibling)
    end
  end

  def position_block_level(node, preceding_sibling:)
    node.clone_with(
      x: preceding_sibling.x,
      y: preceding_sibling.bottom,
    )
  end

  def position_inline(node, preceding_sibling:)
    node.clone_with(
      x: preceding_sibling.right,
      y: preceding_sibling.y,
    )
  end
end
