require "engine"
require "layout_visitors"
require "local_file_image_store"
require "offline_html_fetcher"
require "parser"

OFFLINE_ENGINE = -> (html) {
  Engine.new(
    fetcher: OfflineHtmlFetcher.new(html),
    image_store_factory: LocalFileImageStore.method(:new),
    layout_pipeline: LAYOUT_VISITORS,
    parser: Parser.new,
  )
}
