require "drawing_visitors"
require "engine"
require "fetcher"
require "image_store"
require "layout_visitors"
require "parser"
require "rest-client"

fetcher = Fetcher.new(RestClient)

ONLINE_ENGINE = -> {
  Engine.new(
    drawing_visitors: DRAWING_VISITORS,
    fetcher: fetcher,
    image_store_factory: -> (origin:) {
      ImageStore.new(fetcher: fetcher, origin: origin)
    },
    layout_visitors: LAYOUT_VISITORS,
    parser: Parser.new,
  )
}
