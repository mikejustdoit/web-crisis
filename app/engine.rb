class Engine
  def initialize(fetcher:, layout_pipeline:, parser:)
    @fetcher = fetcher
    @layout_pipeline = layout_pipeline
    @parser = parser
  end

  def request(uri, viewport_width, viewport_height, text_width_calculator)
    layout_pipeline.visit(
      parse(uri),
      viewport_width: viewport_width,
      viewport_height: viewport_height,
      text_width_calculator: text_width_calculator,
    )
  end

  private

  attr_reader :fetcher, :layout_pipeline, :parser

  def parse(uri)
    parser.call(fetch(uri))
  end

  def fetch(uri)
    fetcher.call(uri)
  end
end
