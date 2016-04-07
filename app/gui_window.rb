require "gosu"

class GuiWindow < Gosu::Window
  def initialize(engine)
    @engine = engine

    @address = ""

    @needs_redraw = false

    super(640, 480)

    self.caption = "Web Crisis browser"
  end

  attr_accessor :address

  def draw
    engine.visit(address)

    @needs_redraw = false
  end

  def needs_redraw?
    needs_redraw
  end

  def go
    @needs_redraw = true
  end

  private

  attr_reader :engine, :needs_redraw
end
