require "box"
require "gosu_adapter_stubs"

class WindowDouble
  def initialize(engine:, drawing_visitors:)
    @engine = engine
    @drawing_visitors = drawing_visitors
    @address = ""
    @width = 640
    @height = 480
    @fixed_width_for_word_or_space = 50
  end

  attr_writer :address

  def go
    drawing_visitors.visit(
      engine.request(
        address,
        viewport_width: viewport.width,
        viewport_height: viewport.height,
        text_calculator: gosu_text_calculator_stub(
          returns: [fixed_width_for_word_or_space, 18]
        ),
        image_calculator: gosu_image_calculator_stub(returns: [100, 100]),
      ),
      box_renderer: gosu_box_renderer_stub,
      image_renderer: gosu_image_renderer_stub,
      text_renderer: gosu_text_renderer_stub,
    )
  end

  def resize_window(allow_words_per_row:)
    number_of_words_and_spaces = allow_words_per_row * 2 - 1

    @fixed_width_for_word_or_space = width / number_of_words_and_spaces
  end

  def in_view?(node)
    node.bottom > viewport.y && node.y < viewport.height
  end

  private

  attr_reader :address, :drawing_visitors, :engine, :fixed_width_for_word_or_space,
    :height, :width

  def viewport
    Box.new(x: 0, y: 0, width: width, height: height)
  end
end
