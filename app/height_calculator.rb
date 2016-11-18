class HeightCalculator
  def initialize(**_); end

  def call(node)
    case node
    when Element
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
      height: new_children.map { |child| child.height }.inject(0, &:+),
      children: new_children,
    )
  end

  def visit_text(node)
    node.clone_with(
      height: text_node_height,
    )
  end

  def text_node_height
    18
  end
end
