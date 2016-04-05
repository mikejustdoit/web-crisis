require "gosu"

class GuiWindow < Gosu::Window
  def initialize(engine)
    @engine = engine

    super(640, 480)

    self.caption = "Web Crisis browser"
  end

  private

  attr_reader :engine
end
