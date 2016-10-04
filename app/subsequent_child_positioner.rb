class SubsequentChildPositioner
  def initialize(preceding_sibling_node:)
    @preceding_sibling_node = preceding_sibling_node
  end

  def call(node)
    node.clone_with(
      y: preceding_sibling_node.bottom,
    )
  end

  private

  attr_reader :preceding_sibling_node
end
