class Engine
  def initialize(drawing_visitor:, fetcher:, parser:)
    @drawing_visitor = drawing_visitor
    @fetcher = fetcher
    @parser = parser
  end

  def visit(uri)
    root_node_for(uri).draw(
      drawing_visitor
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
