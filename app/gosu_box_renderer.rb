require "gosu"

class GosuBoxRenderer
  def call(x, y, width, height)
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

  private

  def gosu
    Gosu
  end

  def colour
    Gosu::Color::WHITE
  end
end
