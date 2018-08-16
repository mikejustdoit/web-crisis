require "uri"

class ImageStore
  FILE_SCHEME_PATTERN = /^file:\/\//

  def initialize(fetcher:, image_dimensions_calculator:, logger:)
    @fetcher = fetcher
    @image_dimensions_calculator = image_dimensions_calculator
    @logger = logger
  end

  def [](uri)
    download(uri)
  end

  private

  attr_reader :fetcher, :image_dimensions_calculator, :logger

  def download(uri)
    if is_local_file?(uri)
      name = without_file_scheme(URI.unescape(uri))
    else
      name = filename(uri)

      if !File.exist?(name)
        File.open(name, "wb") { |file| file.print(fetcher.call(uri)) }
      end
    end

    ImageFile.new(name, image_dimensions_calculator: image_dimensions_calculator)

  rescue => e
    logger.call(e.inspect)

    ImageFile.new(PLACEHOLDER_IMAGE, image_dimensions_calculator: image_dimensions_calculator)
  end

  def filename(uri)
    File.join(
      ASSETS,
      "#{uri.gsub(/[^-_0-9a-zA-Z]/, "-")}-#{File.basename(URI.parse(uri).path)}",
    )
  end

  def is_local_file?(uri)
    uri =~ FILE_SCHEME_PATTERN
  end

  def without_file_scheme(uri)
    uri.sub(FILE_SCHEME_PATTERN, "")
  end

  class ImageFile
    def initialize(name, image_dimensions_calculator:)
      @name = name
      @width, @height = image_dimensions_calculator.call(name)
    end

    attr_reader :name, :width, :height
  end
end
