class Engine
  def initialize(drawing_visitor:, fetcher:, parser:)
    @drawing_visitor = drawing_visitor
    @fetcher = fetcher
    @parser = parser
  end

  def request(uri, window_width, window_height)
    drawing_visitor.visit(
      root_node_for(uri)
    )
  end

  private

  attr_reader :drawing_visitor, :fetcher, :parser

  def root_node_for(uri)
    parser.call(fetch(uri))
  end

  def fetch(uri)
    fetcher.call(uri)
  end
end
