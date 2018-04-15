require "node_types"

class BlockLevelReverseInheritor
  def initialize(**_); end

  def call(node)
    case node
    when InlineElement
      visit_inline_element(node)
    when BlockLevelElement
      visit_block_level_element(node)
    when Text
      node
    else
      raise UnrecognisedNodeType
    end
  end

  private

  def visit_inline_element(node)
    new_children = node.children.map { |child|
      call(child)
    }

    return node unless new_children.any? { |child| child.is_a?(BlockLevelElement) }

    BlockLevelElement.new(
      node.clone_with(
        children: new_children,
      )
    )
  end

  def visit_block_level_element(node)
    new_children = node.children.map { |child|
      call(child)
    }

    node.clone_with(
      children: new_children,
    )
  end
end
