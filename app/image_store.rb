class ImageStore
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
    name = filename(uri)

    if !File.exist?(name)
      File.open(name, "wb") { |file| file.print(fetcher.call(uri)) }
    end

    ImageFile.new(name, image_dimensions_calculator: image_dimensions_calculator)

  rescue => e
    logger.call(e.message)

    ImageFile.new(PLACEHOLDER_IMAGE, image_dimensions_calculator: image_dimensions_calculator)
  end

  def filename(uri)
    File.join(
      ASSETS,
      "#{uri.gsub(/[^-_0-9a-zA-Z]/, "-")}-#{File.basename(URI.parse(uri).path)}",
    )
  end

  class ImageFile
    def initialize(name, image_dimensions_calculator:)
      @name = name
      @width, @height = image_dimensions_calculator.call(name)
    end

    attr_reader :name, :width, :height
  end
end
