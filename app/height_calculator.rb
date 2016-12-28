require "node_types"

class HeightCalculator
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

  def visit_element(node)
    new_children = node.children.map { |child|
      call(child)
    }

    node.clone_with(
      height: new_children.map { |child| child.height }.inject(0, &:+),
      children: new_children,
    )
  end
end
