class Engine
  def initialize(drawing_visitor:, fetcher:, layout_visitor_factory:, parser:)
    @drawing_visitor = drawing_visitor
    @fetcher = fetcher
    @layout_visitor_factory = layout_visitor_factory
    @parser = parser
  end

  def request(uri, window_width, window_height)
    drawing_visitor.visit(
      layout_for(uri, window_width, window_height)
    )
  end

  private

  attr_reader :drawing_visitor, :fetcher, :layout_visitor_factory, :parser

  def layout_for(uri, window_width, window_height)
    layout_visitor_factory.call(window_width, window_height)
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
