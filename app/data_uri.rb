require "base64"
require "digest"

class DataUri
  DATA_SCHEME_PATTERN = /^data:/

  def initialize(uri)
    @uri = uri
  end

  def write_to_file
    if !File.exist?(name)
      File.open(name, "wb") { |file|
        file.print(Base64.strict_decode64(just_the_data))
      }
    end
  end

  def name
    File.join(
      ASSETS,
      "#{Digest::SHA256.hexdigest(just_the_data)}.#{file_type}",
    )
  end

  private

  attr_reader :uri

  def just_the_data
    uri.sub(/#{DATA_SCHEME_PATTERN}image\/[a-z]+;base64,/, "")
  end

  def file_type
    /#{DATA_SCHEME_PATTERN}image\/([a-z]+);base64,/.match(uri)[1]
  end
end
