require "cgi"
require "data_uri"
require "pathname"

class LocalFileImageStore
  DATA_SCHEME_PATTERN = /^data:/
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

  def call(uri)
    if is_data_uri?(uri)
      data_uri = DataUri.new(uri)

      data_uri.write_to_file

      data_uri.name
    else
      local_file_filename(uri)
    end

  rescue => e
    logger.call("#{e.inspect} || #{uri}")

    PLACEHOLDER_IMAGE
  end

  private

  attr_reader :origin

  def local_file_filename(uri)
    path = absolute(to_path(CGI.unescape(uri)))

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

  def is_data_uri?(uri)
    uri =~ DATA_SCHEME_PATTERN
  end

  def logger
    LOGGER
  end
end
