class NodeLister
  def call(node)
    if node.respond_to?(:children)
      [node] + node.children.map { |child| call(child) }.flatten
    else
      [node]
    end
  end
end
