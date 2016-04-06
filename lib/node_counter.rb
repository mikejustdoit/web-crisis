class NodeCounter
  def call(node)
    node.map_children(->(child) { call(child) }).inject(1, :+)
  end
end
