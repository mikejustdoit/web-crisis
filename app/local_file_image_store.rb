require "uri"

require "image_file"

class LocalFileImageStore
  FILE_SCHEME_PATTERN = /^file:\/\//

  def initialize(image_dimensions_calculator:)
    @image_dimensions_calculator = image_dimensions_calculator
  end

  def [](uri)
    name = local_file_filename(uri)

    ImageFile.new(name, image_dimensions_calculator: image_dimensions_calculator)

  rescue => e
    logger.call("#{e.inspect} || #{uri}")

    ImageFile.new(PLACEHOLDER_IMAGE, image_dimensions_calculator: image_dimensions_calculator)
  end

  private

  attr_reader :image_dimensions_calculator

  def local_file_filename(uri)
    without_file_scheme(URI.unescape(uri))
  end

  def without_file_scheme(uri)
    uri.sub(FILE_SCHEME_PATTERN, "")
  end

  def logger
    LOGGER
  end
end
