require "box"
require "gosu_adapter_stubs"

class WindowDouble
  def initialize(engine:)
    @engine = engine
    @width = 640
    @height = 480
    @fixed_width_for_word_or_space = 50
  end

  def address=(new_address)
    engine.uri = new_address
  end

  def go
    engine.render(
      viewport_width: viewport.width,
      viewport_height: viewport.height,
      text_calculator: gosu_text_calculator_stub(
        returns: [fixed_width_for_word_or_space, 18]
      ),
      image_calculator: gosu_image_calculator_stub(returns: [100, 100]),
      box_renderer: gosu_box_renderer_stub,
      image_renderer: gosu_image_renderer_stub,
      text_renderer: gosu_text_renderer_stub,
    )
  end

  def allow_words_per_row(n)
    @fixed_width_for_word_or_space = width / n
  end

  def in_view?(node)
    viewport.overlaps?(node)
  end

  private

  attr_reader :engine, :fixed_width_for_word_or_space, :height, :width

  def viewport
    Box.new(x: 0, y: 0, width: width, height: height)
  end
end
