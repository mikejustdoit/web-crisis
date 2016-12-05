class FirstChildPositioner
  def call(node, parent_node:)
    node.clone_with(
      x: parent_node.x,
      y: parent_node.y,
    )
  end
end
