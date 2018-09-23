require "uri"
require "data_uri"

class ImageStore
  DATA_SCHEME_PATTERN = /^data:/

  def initialize(fetcher:)
    @fetcher = fetcher
  end

  def [](uri)
    download(uri)
  end

  private

  attr_reader :fetcher

  def download(uri)
    if is_data_uri?(uri)
      data_uri = DataUri.new(uri)

      data_uri.write_to_file

      name = data_uri.name
    else
      name = remote_image_to_filename(uri)

      if !File.exist?(name)
        File.open(name, "wb") { |file| file.print(fetcher.call(uri)) }
      end
    end

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
