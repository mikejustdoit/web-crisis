class Engine
  def initialize(drawing_visitor_factory:, fetcher:, layout_visitor_factory:, parser:)
    @drawing_visitor_factory = drawing_visitor_factory
    @fetcher = fetcher
    @layout_visitor_factory = layout_visitor_factory
    @parser = parser
  end

  def request(uri, window_width, window_height, box_renderer, text_renderer)
    drawing_visitor_factory.call(
      box_renderer: box_renderer,
      text_renderer: text_renderer,
    )
      .visit(
        layout_for(uri, window_width, window_height)
      )
  end

  private

  attr_reader :drawing_visitor_factory, :fetcher, :layout_visitor_factory, :parser

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
