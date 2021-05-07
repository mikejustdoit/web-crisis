require "drawing_visitors"
require "engine"
require "layout_visitors"
require "local_file_image_store"
require "offline_html_fetcher"
require "parser"

OFFLINE_ENGINE = -> (html) {
  Engine.new(
    build_uri_factory: -> (origin:) { -> (uri) { uri } },
    drawing_visitors: DRAWING_VISITORS,
    fetcher: OfflineHtmlFetcher.new(html),
    image_store_factory: LocalFileImageStore.method(:new),
    layout_visitors: LAYOUT_VISITORS,
    parser: Parser.new,
  )
}
