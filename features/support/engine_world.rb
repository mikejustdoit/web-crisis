require "engine"
require "fetcher"
require "height_calculator"
require "inspector"
require "layout_pipeline"
require "parser"
require "position_calculator"
require "root_node_dimensions_setter"

module EngineWorld
  def engine
    @engine ||= Engine.new(
      fetcher: Fetcher.new,
      layout_pipeline: LayoutPipeline.new(
        [
          RootNodeDimensionsSetter.method(:new),
          HeightCalculator.method(:new),
          PositionCalculator.method(:new),
        ]
      ),
      parser: Parser.new,
    )
  end

  def visit_address(new_address)
    @render_tree = engine.request(new_address, viewport_width, viewport_height)
  end

  def viewport_width
    640
  end

  def viewport_height
    480
  end

  def page_displays_heading(text)
    expect_text_to_be_at_top(text)
  end

  def expect_text_to_be_at_top(text)
    node = page.find_nodes_with_text(text).first

    expect(node.box.y).to be < 100
  end

  def page
    Inspector.new(@render_tree)
  end
end

World(EngineWorld)
