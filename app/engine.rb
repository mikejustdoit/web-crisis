class Engine
  def initialize(fetcher:, image_store_factory:, layout_visitors:, parser:)
    @fetcher = fetcher
    @image_store_factory = image_store_factory
    @layout_visitors = layout_visitors
    @parser = parser
  end

  def request(uri, viewport_width:, viewport_height:, text_calculator:, image_calculator:)
    layout_visitors.visit(
      parse(uri),
      viewport_width: viewport_width,
      viewport_height: viewport_height,
      text_calculator: text_calculator,
      image_calculator: image_calculator,
      image_store: image_store_factory.call(origin: uri),
    )
  end

  private

  attr_reader :fetcher, :image_store_factory, :layout_visitors, :parser

  def parse(uri)
    parser.call(fetch(uri))
  end

  def fetch(uri)
    fetcher.call(uri)
  end
end
