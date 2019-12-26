require "forwardable"
require "point"
require "text_bounds"

class Text
  extend Forwardable

  class OutOfContentRange < StandardError; end

  def initialize(box:, colour:, rows:)
    @box = box
    @colour = colour
    @rows = rows
  end

  attr_reader :colour, :rows

  def_delegators :box, :x, :y, :width, :height, :right, :bottom

  def content
    rows.map(&:content).join(" ")
  end

  def clone_with(**attributes)
    Text.new(
      box: box.clone_with(**attributes),
      rows: attributes.fetch(:rows, rows),
      colour: attributes.fetch(:colour, colour),
    )
  end

  def position_after(preceding_node)
    point = preceding_node.next_available_point
    clone_with(
      x: point.x,
      y: point.y,
    )
  end

  def next_available_point
    Point.new(x: x, y: y) + rows.last.next_available_point
  end

  def maximum_bounds
    TextBounds.new
  end

  def bounding_boxes_for_substring(content_range)
    unless (0..content.size).cover?(content_range)
      raise OutOfContentRange.new(content_range)
    end

    string = AnnotatedString.new

    rows.each do |text_row|
      string.append(text_row.content, text_row)
    end

    string.overlapping(content_range).map(&:last).map(&Box.method(:from))
  end

  private

  attr_reader :box

  class AnnotatedString
    def initialize
      @annotations = []
      @string = ""
    end

    def append(addition, metadata)
      @annotations.push([(@string.size)...(@string.size + addition.size), metadata])

      @string.concat(addition)
    end

    def overlapping(range)
      from = range.min
      to = range.max

      annotations.select { |location, _metadata|
        location.include?(from) || location.include?(to)
      }
    end

    private

    attr_reader :annotations, :string
  end
end
