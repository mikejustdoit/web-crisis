require "engine"
require "fetcher"
require "image_store"
require "layout_visitors"
require "parser"

ONLINE_ENGINE = -> {
  Engine.new(
    fetcher: Fetcher.new,
    image_store_factory: -> (origin:) { ImageStore.new(fetcher: Fetcher.new, origin: origin) },
    layout_visitors: LAYOUT_VISITORS,
    parser: Parser.new,
  )
}
