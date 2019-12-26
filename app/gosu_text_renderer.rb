require "gosu"

class GosuTextRenderer
  def initialize(viewport)
    @viewport = viewport
  end

  def call(text, x:, y:, colour:)
    translate_viewport_to_gui(x, y) do |gui_x, gui_y|
      font.draw_text(text, gui_x, gui_y, 0, 1.0, 1.0, gosu_colour(colour))
    end
  end

  private

  attr_reader :viewport

  def translate_viewport_to_gui(x, y, &block)
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

  def gosu_colour(colour)
    {
      :black => Gosu::Color::BLACK,
      :blue => Gosu::Color::BLUE,
    }.fetch(colour)
  end
end
