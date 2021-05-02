require "build_uri"
require "element"
require "inspector"
require "point"

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
    @render_tree = Element.new
    @uri = nil
  end

  attr_reader :render_tree

  def uri=(new_uri)
    @uri = BuildUri.new(origin: uri).call(new_uri)
  end

  def render(
    viewport_width:,
    viewport_height:,
    text_calculator:,
    image_calculator:,
    box_renderer:,
    image_renderer:,
    text_renderer:
  )
    @render_tree = drawing_visitors.visit(
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

    render_tree
  end

  def click(x, y, gui)
    target = Inspector.new(render_tree).find_element_at(Point.new(x: x, y: y))

    return if target.nil?

    if target.respond_to?(:href) && !target.href.nil? && !target.href.empty?
      self.uri = target.href
      gui.needs_redraw!
    end
  end

  private

  attr_reader :drawing_visitors,
    :fetcher,
    :image_store_factory,
    :layout_visitors,
    :parser,
    :uri
end
