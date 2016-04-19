require "gosu"
require "gosu_box_renderer"
require "gosu_text_renderer"

class GuiWindow < Gosu::Window
  def initialize(engine:, drawing_visitor_factory:, finished_draw: default_callback)
    @engine = engine
    @drawing_visitor_factory = drawing_visitor_factory
    @finished_draw = finished_draw

    @address = ""

    @needs_redraw = false

    super(640, 480)

    self.caption = "Web Crisis browser"
  end

  attr_accessor :address

  def draw
    drawing_visitor.visit(
      engine.request(
        address,
        viewport_width,
        viewport_height,
      )
    )

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

  attr_reader :drawing_visitor_factory, :engine, :finished_draw, :needs_redraw

  def default_callback
    -> {}
  end

  def drawing_visitor
    drawing_visitor_factory.call(
      box_renderer: box_renderer,
      text_renderer: text_renderer,
    )
  end

  def viewport_width
    width
  end

  def viewport_height
    height
  end

  def box_renderer
    GosuBoxRenderer.new
  end

  def text_renderer
    GosuTextRenderer.new
  end
end
