require "gosu"

class GosuImageCalculator
  class Error < StandardError; end

  def call(filename)
    begin
      image = Gosu::Image.new(filename)
    rescue RuntimeError => e
      raise GosuImageCalculator::Error.new(
        "Caught '#{e}' while attempting to open #{filename}"
      )
    end

    return image.width, image.height
  end
end
