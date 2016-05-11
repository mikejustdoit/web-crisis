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

    node.clone_with(
      box: Box.new(
        node.box.x,
        node.box.y,
        node.box.width,
        new_children.map { |child| child.box.height }.inject(0, &:+),
      ),
      children: new_children,
    )
  end

  def visit_text(node)
    node.clone_with(
      box: Box.new(
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
