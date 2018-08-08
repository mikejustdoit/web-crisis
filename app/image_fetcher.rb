class ImageFetcher
  def initialize(image_store:, **)
    @image_store = image_store
  end

  def call(node)
    if node.respond_to?(:src)
      file = image_store[node.src]

      node.clone_with(
        width: file.width,
        height: file.height,
        filename: file.name,
      )
    elsif node.respond_to?(:children)
      node.clone_with(children: node.children.map(&method(:call)))
    else
      node
    end
  end

  private

  attr_reader :image_store
end
