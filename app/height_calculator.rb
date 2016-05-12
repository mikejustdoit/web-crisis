class HeightCalculator
  def initialize(**_); end

  def visit(tree)
    tree.accept_visit(self)
  end

  def visit_element(node)
    new_children = node.children.map { |child|
      child.accept_visit(self)
    }

    node.clone_with(
      box: node.box.clone_with(
        height: new_children.map { |child| child.height }.inject(0, &:+),
      ),
      children: new_children,
    )
  end

  def visit_text(node)
    node.clone_with(
      box: node.box.clone_with(
        height: text_node_height,
      )
    )
  end

  private

  def text_node_height
    18
  end
end
