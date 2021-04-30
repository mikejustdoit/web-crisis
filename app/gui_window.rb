require "box"
require "gosu"
require "gosu_box_renderer"
require "gosu_image_calculator"
require "gosu_image_renderer"
require "gosu_text_renderer"
require "gosu_text_calculator"

class GuiWindow < Gosu::Window
  def initialize(engine:)
    @engine = engine
    @needs_redraw = false

    super(640, 480)
    self.caption = "Web Crisis browser"
  end

  def address=(new_address)
    engine.uri = new_address
  end

  def draw
    engine.render(
      viewport_width: viewport.width,
      viewport_height: viewport.height,
      text_calculator: GosuTextCalculator.new,
      image_calculator: GosuImageCalculator.new,
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

    show
  end

  private

  attr_reader :engine, :needs_redraw

  def viewport
    Box.new(x: 0, y: 0, width: width, height: height)
  end
end
