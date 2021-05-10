class RootNodeDimensionsSetter
  def initialize(viewport_width:, **)
    @viewport_width = viewport_width
  end

  def call(node)
    node.clone_with(
      x: 0,
      y: 0,
      width: viewport_width,
    )
  end

  private

  attr_reader :viewport_width
end
