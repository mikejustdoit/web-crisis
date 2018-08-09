require "box"
require "gosu"
require "gosu_box_renderer"
require "gosu_image_renderer"
require "gosu_text_renderer"
require "gosu_text_width_calculator"

class GuiWindow < Gosu::Window
  def initialize(engine:, drawing_visitors:)
    @engine = engine
    @drawing_visitors = drawing_visitors

    @address = ""

    @needs_redraw = false

    super(640, 480)

    self.caption = "Web Crisis browser"
  end

  attr_accessor :address

  def draw
    drawing_visitors.visit(
      engine.request(
        address,
        viewport_width,
        viewport_height,
        GosuTextWidthCalculator.new,
      ),
      box_renderer: box_renderer,
      image_renderer: image_renderer,
      text_renderer: text_renderer,
    )

    @needs_redraw = false
  end

  def needs_redraw?
    needs_redraw
  end

  def go
    @needs_redraw = true
  end

  private

  attr_reader :drawing_visitors, :engine, :needs_redraw

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

  def image_renderer
    GosuImageRenderer.new(viewport)
  end

  def text_renderer
    GosuTextRenderer.new(viewport)
  end
end
