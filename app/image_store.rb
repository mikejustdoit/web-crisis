require "build_uri"
require "image"
require "uri"
require "data_uri"

class ImageStore
  DATA_SCHEME_PATTERN = /^data:/

  def initialize(fetcher:, origin:)
    @fetcher = fetcher
    @origin = origin
  end

  def call(uri)
    if is_data_uri?(uri)
      return DataUri.new(uri).tap { |du| du.write_to_file }.name
    end

    download(
      BuildUri.new(origin: origin).call(uri)
    )
  end

  private

  attr_reader :fetcher, :origin

  def download(uri)
    name = remote_image_to_filename(uri)

    File.open(name, "wb") { |file|
      file.print(fetcher.call(uri, accept: Image::SUPPORTED_MIME_TYPES))
    }

    name

  rescue => e
    logger.call("#{e.inspect} || #{uri}")

    PLACEHOLDER_IMAGE
  end

  def remote_image_to_filename(uri)
    File.join(
      ASSETS,
      "#{uri.gsub(/[^-_0-9a-zA-Z]/, "-")}-#{File.basename(URI.parse(uri).path)}",
    )
  end

  def is_data_uri?(uri)
    uri =~ DATA_SCHEME_PATTERN
  end

  def logger
    LOGGER
  end
end
