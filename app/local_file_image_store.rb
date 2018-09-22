require "uri"

class LocalFileImageStore
  FILE_SCHEME_PATTERN = /^file:\/\//

  class FileNotFound < StandardError
    def initialize(path)
      super("'#{path}' not found on disk")
    end
  end

  def initialize(origin:)
    @origin = File.dirname(File.expand_path(origin))
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
    path = without_file_scheme(URI.unescape(uri))

    raise FileNotFound.new(path) unless File.exist?(path)

    path
  end

  def without_file_scheme(uri)
    uri.sub(FILE_SCHEME_PATTERN, "")
  end

  def logger
    LOGGER
  end
end
