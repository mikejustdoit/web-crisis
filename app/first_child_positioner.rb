class FirstChildPositioner
  def initialize(parent_node:)
    @parent_node = parent_node
  end

  def call(node)
    node.clone_with(
      y: parent_node.y,
    )
  end

  private

  attr_reader :parent_node
end
