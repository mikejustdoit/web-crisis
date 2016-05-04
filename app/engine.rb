class Engine
  def initialize(fetcher:, layout_visitor_factory:, parser:)
    @fetcher = fetcher
    @layout_visitor_factory = layout_visitor_factory
    @parser = parser
  end

  def request(uri, viewport_width, viewport_height)
    layout_for(uri, viewport_width, viewport_height)
  end

  private

  attr_reader :fetcher, :layout_visitor, :parser

  def layout_for(uri, viewport_width, viewport_height)
    layout_visitor_factory
      .call(
        viewport_width: viewport_width,
        viewport_height: viewport_height,
      )
      .visit(
        root_node_for(uri)
      )
  end

  def root_node_for(uri)
    parser.call(fetch(uri))
  end

  def fetch(uri)
    fetcher.call(uri)
  end
end
