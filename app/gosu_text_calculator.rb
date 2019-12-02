require "gosu"

class GosuTextCalculator
  def call(text_line)
    return font.text_width(text_line), line_height
  end

  private

  def font
    @font ||= Gosu::Font.new(height, {:name => name})
  end

  def height
    14
  end

  def line_height
    18
  end

  def name
    "Comic Sans"
  end
end
