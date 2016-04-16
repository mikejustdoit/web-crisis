require "gosu"

class GosuTextRenderer
  def call(text, x, y)
    font.draw(text, x, y, 0, 1.0, 1.0, colour)
  end

  private

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
