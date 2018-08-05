require "gosu"

class GosuImageDimensionsCalculator
  def call(filename)
    image = Gosu::Image.new(filename)

    return image.width, image.height
  end
end
