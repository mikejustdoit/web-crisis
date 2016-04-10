require "gosu"

class GuiWindow < Gosu::Window
  def initialize(engine, finished_draw = default_callback)
    @engine = engine
    @finished_draw = finished_draw

    @address = ""

    @needs_redraw = false

    super(640, 480)

    self.caption = "Web Crisis browser"
  end

  attr_accessor :address

  def draw
    engine.request(address, width, height)

    @needs_redraw = false

    finished_draw.call
  end

  def needs_redraw?
    needs_redraw
  end

  def go
    @needs_redraw = true
  end

  private

  attr_reader :engine, :finished_draw, :needs_redraw

  def default_callback
    -> {}
  end
end
