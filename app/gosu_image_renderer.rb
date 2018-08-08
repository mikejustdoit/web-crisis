require "gosu"

class GosuImageRenderer
  def initialize(viewport)
    @viewport = viewport
  end

  def call(filename, viewport_world_x, viewport_world_y)
    translate(viewport_world_x, viewport_world_y) do |x, y|
      Gosu::Image.new(filename).draw(x, y, z)
    end
  end

  private

  attr_reader :viewport

  def translate(x, y, &block)
    block.call(viewport.x + x, viewport.y + y)
  end

  def z
    0
  end
end
