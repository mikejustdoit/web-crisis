class SubsequentChildPositioner
  def call(node, preceding_sibling_node:)
    node.clone_with(
      y: preceding_sibling_node.bottom,
    )
  end
end
