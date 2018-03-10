require "text"

class BuildText
  def call(box: Box.new, content:)
    Text.new(box: box, content: content)
  end
end
