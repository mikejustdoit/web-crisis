class AbsolutePositionAdderUpper
  def initialize(**_); end

  def call(node, parent_node_x: 0, parent_node_y: 0)
    visit_node(node, parent_node_x: parent_node_x, parent_node_y: parent_node_y)
  end

  private

  def visit_node(node, parent_node_x:, parent_node_y:)
    absolute_x = node.x + parent_node_x
    absolute_y = node.y + parent_node_y

    node.clone_with(
      children: node.children.map { |child|
        call(child, parent_node_x: absolute_x, parent_node_y: absolute_y)
      },
      x: absolute_x,
      y: absolute_y,
    )
  end
end
