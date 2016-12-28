require "node_types"

class WidthCalculator
  def initialize(**_); end

  def call(node)
    case node
    when *ELEMENTS
      visit_element(node)
    when Text
      visit_text(node)
    end
  end

  private

  def visit_element(node)
    new_children = node.children.map { |child|
      call(child)
    }

    node.clone_with(
      width: new_children.map { |child| child.width }.reduce(0, &:+),
      children: new_children,
    )
  end

  def visit_text(node)
    node
  end
end
