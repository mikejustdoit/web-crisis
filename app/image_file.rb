class ImageFile
  def initialize(name, image_dimensions_calculator:)
    @name = name
    @width, @height = image_dimensions_calculator.call(name)
  end

  attr_reader :name, :width, :height
end
