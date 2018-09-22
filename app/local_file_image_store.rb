require "pathname"
require "uri"

class LocalFileImageStore
  FILE_SCHEME_PATTERN = /^file:\/\//

  class FileNotAccessible < StandardError
    def initialize(path, origin)
      super("'#{path}' not a descendant of origin '#{origin}'")
    end
  end

  class FileNotFound < StandardError
    def initialize(path)
      super("'#{path}' not found on disk")
    end
  end

  def initialize(origin:)
    @origin = Pathname.new(origin).expand_path.dirname
  end

  def [](uri)
    local_file_filename(uri)

  rescue => e
    logger.call("#{e.inspect} || #{uri}")

    PLACEHOLDER_IMAGE
  end

  private

  attr_reader :origin

  def local_file_filename(uri)
    path = absolute(to_path(URI.unescape(uri)))

    raise FileNotFound.new(path) unless File.exist?(path)

    raise FileNotAccessible.new(path, origin) unless descendant_of_origin?(path)

    path.to_s
  end

  def descendant_of_origin?(path)
    path.ascend.to_a.include?(origin)
  end

  def absolute(path)
    return path if path.absolute?

    path.expand_path(origin)
  end

  def to_path(uri)
    Pathname.new(
      uri.sub(FILE_SCHEME_PATTERN, "")
    )
  end

  def logger
    LOGGER
  end
end
