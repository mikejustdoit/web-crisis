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

    expect(node.y).to be < viewport_height / 2
  end

  def page
    Inspector.new(@render_tree)
  end
end

World(EngineWorld)

module OfflineHtmlWorld
  class OfflineHtmlFetcher
    def initialize(body)
      @body = body
    end

    def call(uri)
      body
    end

    private

    attr_reader :body
  end

  def offline_html_engine(html_input)
    Engine.new(
      fetcher: OfflineHtmlFetcher.new(html_input),
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

  def render_in_browser(html_input)
    @render_tree = offline_html_engine(html_input)
      .request("https://dummy.address", viewport_width, viewport_height)
  end

  def elements_are_positioned_left_to_right
    first_node = page.find_nodes_with_text("Your").first
    second_node = page.find_nodes_with_text("ad").first
    third_node = page.find_nodes_with_text("here").first

    expect(second_node.x).to be >= first_node.right
    expect(third_node.x).to be >= second_node.right
  end

  def root_node_is_at_least_as_wide_as_all_of_its_chilren
    parent_node = @render_tree

    first_child_node = page.find_nodes_with_text("Your").first
    second_child_node = page.find_nodes_with_text("ad").first
    third_child_node = page.find_nodes_with_text("here").first

    expect(parent_node.width).to be >=
      first_child_node.width + second_child_node.width + third_child_node.width
  end
end

World(OfflineHtmlWorld)
