require "box"

class HeightCalculator
  def initialize(**_); end

  def visit(tree)
    tree.accept_visit(self)
  end

  def visit_element(node)
    new_children = node.children.map { |child|
      child.accept_visit(self)
    }

    node.with_children(new_children)
      .with_box(
        Box.new(
          node.box.x,
          node.box.y,
          node.box.width,
          new_children.map { |child| child.box.height }.inject(0, &:+),
        )
      )
  end

  def visit_text(node)
    node.with_box(
      Box.new(
        node.box.x,
        node.box.y,
        node.box.width,
        text_node_height,
      )
    )
  end

  private

  def text_node_height
    18
  end
end
