class NodeCounter
  def call(node)
    return 1 unless node.respond_to?(:children)

    node.children.map(&method(:call)).inject(1, :+)
  end
end
