class ImageFetcher
  def initialize(fetcher:, image_dimensions_calculator:, **)
    @fetcher = fetcher
    @image_dimensions_calculator = image_dimensions_calculator
  end

  def call(node)
    if node.respond_to?(:src)
      file = download(node.src)

      node.clone_with(
        width: file.width,
        height: file.height,
        filename: file.name,
      )
    elsif node.respond_to?(:children)
      node.clone_with(children: node.children.map(&method(:call)))
    else
      node
    end
  end

  private

  attr_reader :fetcher, :image_dimensions_calculator

  def download(uri)
    name = filename(uri)

    File.open(name, "wb") { |file| file.print(fetcher.call(uri)) }

    ImageFile.new(name, image_dimensions_calculator: image_dimensions_calculator)
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
