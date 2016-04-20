require "gosu"

class GosuBoxRenderer
  def initialize(viewport)
    @viewport = viewport
  end

  def call(viewport_world_x, viewport_world_y, width, height)
    translate(viewport_world_x, viewport_world_y) do |x, y|
      gosu.draw_quad(
        x,
        y,
        colour,
        x + width,
        y,
        colour,
        x,
        y + height,
        colour,
        x + width,
        y + height,
        colour,
      )
    end
  end

  private

  attr_reader :viewport

  def translate(x, y, &block)
    block.call(viewport.x + x, viewport.y + y)
  end

  def gosu
    Gosu
  end

  def colour
    Gosu::Color::WHITE
  end
end
