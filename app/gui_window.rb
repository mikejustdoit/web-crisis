require "box"
require "gosu"
require "gosu_box_renderer"
require "gosu_image_dimensions_calculator"
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

  attr_writer :address

  def draw
    drawing_visitors.visit(
      engine.request(
        address,
        viewport_width: viewport.width,
        viewport_height: viewport.height,
        text_width_calculator: GosuTextWidthCalculator.new,
        image_dimensions_calculator: GosuImageDimensionsCalculator.new,
      ),
      box_renderer: GosuBoxRenderer.new(viewport),
      image_renderer: GosuImageRenderer.new(viewport),
      text_renderer: GosuTextRenderer.new(viewport),
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

  attr_reader :address, :drawing_visitors, :engine, :needs_redraw

  def viewport
    Box.new(x: 0, y: 0, width: width, height: height)
  end
end
