require "box"
require "gosu_adapter_stubs"

class WindowDouble
  include ::RSpec::Mocks::ExampleMethods

  def initialize(engine:)
    @engine = engine
    @height = 480
    @text_calculator = gosu_text_calculator_stub(returns: [30, 18])
    @width = 640
  end

  def address=(new_address)
    engine.uri = new_address
  end

  def go
    engine.render(
      viewport_width: viewport.width,
      viewport_height: viewport.height,
      text_calculator: text_calculator,
      image_calculator: gosu_image_calculator_stub(returns: [100, 100]),
      box_renderer: gosu_box_renderer_stub,
      image_renderer: gosu_image_renderer_stub,
      text_renderer: gosu_text_renderer_stub,
    )
  end

  def allow_words_per_row(n)
    fixed_width_for_word = width / n

    allow(text_calculator).to receive(:call).and_return(
      [fixed_width_for_word, 18]
    )

    allow(text_calculator).to receive(:call).with(/\A\s+\Z/).and_return(
      [0, 0]
    )
  end

  def in_view?(node)
    viewport.overlaps?(node)
  end

  private

  attr_reader :engine,
    :fixed_width_for_word_or_space,
    :height,
    :text_calculator,
    :width

  def viewport
    Box.new(x: 0, y: 0, width: width, height: height)
  end
end
