class FirstChildPositioner
  def call(node, parent_node:)
    node.clone_with(
      y: parent_node.y,
    )
  end
end
