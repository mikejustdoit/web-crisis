class RootNodeDimensionsSetter
  def initialize(viewport_width:, viewport_height:, **)
    @viewport_width = viewport_width
    @viewport_height = viewport_height
  end

  def call(node)
    node.clone_with(
      x: 0,
      y: 0,
      width: viewport_width,
      height: viewport_height,
    )
  end

  private

  attr_reader :viewport_width, :viewport_height
end
