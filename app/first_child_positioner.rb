class FirstChildPositioner
  def call(node)
    node.clone_with(
      x: 0,
      y: 0,
    )
  end
end
