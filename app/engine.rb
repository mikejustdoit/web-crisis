class Engine
  def initialize(fetcher:, layout_pipeline:, parser:)
    @fetcher = fetcher
    @layout_pipeline = layout_pipeline
    @parser = parser
  end

  def request(uri, viewport_width, viewport_height)
    layout_for(uri, viewport_width, viewport_height)
  end

  private

  attr_reader :fetcher, :layout_pipeline, :parser

  def layout_for(uri, viewport_width, viewport_height)
    layout_pipeline.visit(
      root_node_for(uri),
      viewport_width: viewport_width,
      viewport_height: viewport_height,
    )
  end

  def root_node_for(uri)
    parser.call(fetch(uri))
  end

  def fetch(uri)
    fetcher.call(uri)
  end
end
