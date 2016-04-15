require "engine"
require "fetcher"
require "parser"
require "root_node_dimensions_setter"

module EngineWorld
  def engine
    @engine ||= Engine.new(
      fetcher: Fetcher.new,
      layout_visitor_factory: layout_visitor_factory,
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

  def page_contains(text)
  end

  def layout_visitor_factory
    RootNodeDimensionsSetter.method(:new)
  end
end

World(EngineWorld)
