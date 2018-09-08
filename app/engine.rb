class Engine
  def initialize(fetcher:, image_store_factory:, layout_pipeline:, parser:)
    @fetcher = fetcher
    @image_store_factory = image_store_factory
    @layout_pipeline = layout_pipeline
    @parser = parser
  end

  def request(uri, viewport_width:, viewport_height:, text_width_calculator:, image_dimensions_calculator:)
    layout_pipeline.visit(
      parse(uri),
      viewport_width: viewport_width,
      viewport_height: viewport_height,
      text_width_calculator: text_width_calculator,
      image_dimensions_calculator: image_dimensions_calculator,
      image_store: image_store_factory.call(origin: uri),
    )
  end

  private

  attr_reader :fetcher, :image_store_factory, :layout_pipeline, :parser

  def parse(uri)
    parser.call(fetch(uri))
  end

  def fetch(uri)
    fetcher.call(uri)
  end
end
