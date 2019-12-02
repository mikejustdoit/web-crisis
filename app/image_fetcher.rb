class ImageFetcher
  def initialize(image_calculator:, image_store:, **)
    @image_calculator = image_calculator
    @image_store = image_store
  end

  def call(node)
    if node.respond_to?(:src)
      name = image_store[node.src]
      width, height = image_calculator.call(name)

      node.clone_with(
        width: width,
        height: height,
        filename: name,
      )
    elsif node.respond_to?(:children)
      node.clone_with(children: node.children.map(&method(:call)))
    else
      node
    end
  end

  private

  attr_reader :image_calculator, :image_store
end
