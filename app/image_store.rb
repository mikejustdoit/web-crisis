require "uri"
require "digest"
require "base64"

require "image_file"

class ImageStore
  DATA_SCHEME_PATTERN = /^data:/

  def initialize(fetcher:, image_dimensions_calculator:)
    @fetcher = fetcher
    @image_dimensions_calculator = image_dimensions_calculator
  end

  def [](uri)
    download(uri)
  end

  private

  attr_reader :fetcher, :image_dimensions_calculator

  def download(uri)
    if is_data_uri?(uri)
      name = data_uri_to_filename(uri)

      if !File.exist?(name)
        File.open(name, "wb") { |file|
          file.print(Base64.strict_decode64(just_the_data(uri)))
        }
      end
    else
      name = remote_image_to_filename(uri)

      if !File.exist?(name)
        File.open(name, "wb") { |file| file.print(fetcher.call(uri)) }
      end
    end

    ImageFile.new(name, image_dimensions_calculator: image_dimensions_calculator)

  rescue => e
    logger.call("#{e.inspect} || #{uri}")

    ImageFile.new(PLACEHOLDER_IMAGE, image_dimensions_calculator: image_dimensions_calculator)
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

  def just_the_data(uri)
    uri.sub(/#{DATA_SCHEME_PATTERN}image\/[a-z]+;base64,/, "")
  end

  def file_type(uri)
    /#{DATA_SCHEME_PATTERN}image\/([a-z]+);base64,/.match(uri)[1]
  end

  def data_uri_to_filename(uri)
    File.join(
      ASSETS,
      "#{Digest::SHA256.hexdigest(just_the_data(uri))}.#{file_type(uri)}",
    )
  end

  def logger
    LOGGER
  end
end
