require "gosu"

class GuiWindow < Gosu::Window
  def initialize
    super(640, 480)

    self.caption = "Web Crisis browser"
  end
end
