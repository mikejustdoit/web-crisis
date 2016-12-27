require "gosu"

class GosuTextWidthCalculator
  def call(text_line)
    font.text_width(text_line)
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
end
