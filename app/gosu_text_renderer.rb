require "gosu"

class GosuTextRenderer
  def initialize(viewport)
    @viewport = viewport
  end

  def call(text, viewport_world_x, viewport_world_y)
    translate(viewport_world_x, viewport_world_y) do |x, y|
      font.draw(text, x, y, 0, 1.0, 1.0, colour)
    end
  end

  private

  attr_reader :viewport

  def translate(x, y, &block)
    block.call(viewport.x + x, viewport.y + y)
  end

  def font
    @font ||= Gosu::Font.new(height, {:name => name})
  end

  def height
    14
  end

  def name
    "Comic Sans"
  end

  def colour
    Gosu::Color::BLACK
  end
end
