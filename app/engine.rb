class Engine
  def initialize(
    drawing_visitors:,
    fetcher:,
    image_store_factory:,
    layout_visitors:,
    parser:
  )
    @drawing_visitors = drawing_visitors
    @fetcher = fetcher
    @image_store_factory = image_store_factory
    @layout_visitors = layout_visitors
    @parser = parser
  end

  def render(
    uri,
    viewport_width:,
    viewport_height:,
    text_calculator:,
    image_calculator:,
    box_renderer:,
    image_renderer:,
    text_renderer:
  )
    drawing_visitors.visit(
      layout_visitors.visit(
        parser.call(
          fetcher.call(uri, accept: parser.supported_mime_types),
        ),
        viewport_width: viewport_width,
        viewport_height: viewport_height,
        text_calculator: text_calculator,
        image_calculator: image_calculator,
        image_store: image_store_factory.call(origin: uri),
      ),
      box_renderer: box_renderer,
      image_renderer: image_renderer,
      text_renderer: text_renderer,
    )
  end

  private

  attr_reader :drawing_visitors,
    :fetcher,
    :image_store_factory,
    :layout_visitors,
    :parser
end
