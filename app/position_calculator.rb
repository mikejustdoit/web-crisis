require "node_types"
require "siblings_arranger"

class PositionCalculator
  def initialize(**_); end

  def call(node)
    case node
    when *ELEMENTS
      visit_element(node)
    when Text
      node
    end
  end

  private

  def visit_element(positioned_node)
    new_children = position_children(positioned_node.children)

    positioned_node.clone_with(
      children: new_children.map { |positioned_child|
        call(positioned_child)
      }
    )
  end

  def position_children(children)
    SiblingsArranger.new.call(children)
  end
end
