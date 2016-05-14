require "box"
require "gosu"
require "gosu_box_renderer"
require "gosu_text_renderer"

class GuiWindow < Gosu::Window
  def initialize(engine:, drawing_visitor_factory:)
    @engine = engine
    @drawing_visitor_factory = drawing_visitor_factory

    @address = ""

    @needs_redraw = false

    super(640, 480)

    self.caption = "Web Crisis browser"
  end

  attr_accessor :address

  def draw
    engine.request(
      address,
      viewport_width,
      viewport_height,
    )
    .accept_visit(drawing_visitor)

    @needs_redraw = false
  end

  def needs_redraw?
    needs_redraw
  end

  def go
    @needs_redraw = true
  end

  private

  attr_reader :drawing_visitor_factory, :engine, :needs_redraw

  def drawing_visitor
    drawing_visitor_factory.call(
      box_renderer: box_renderer,
      text_renderer: text_renderer,
    )
  end

  def viewport_x
    0
  end

  def viewport_y
    0
  end

  def viewport_width
    width
  end

  def viewport_height
    height
  end

  def viewport
    Box.new(
      x: viewport_x,
      y: viewport_y,
      width: viewport_width,
      height: viewport_height,
    )
  end

  def box_renderer
    GosuBoxRenderer.new(viewport)
  end

  def text_renderer
    GosuTextRenderer.new(viewport)
  end
end
