require "node_counter"

module TreeWorld
  def tree_size(tree)
    node_counter.call(tree)
  end

  def node_counter
    NodeCounter.new
  end
end

World(TreeWorld)
