class NodeCounter
  def call(node)
    node.children.map(&method(:call)).inject(1, :+)
  end
end
