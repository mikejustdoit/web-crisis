require "gosu"

class GuiWindow < Gosu::Window
  def initialize(engine)
    @engine = engine

    @address = ""

    super(640, 480)

    self.caption = "Web Crisis browser"
  end

  attr_accessor :address

  def go
    engine.visit(address)
  end

  private

  attr_reader :engine
end
