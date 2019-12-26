require "box"

class TextSearch
  def initialize(render_tree)
    @string = SearchableAnnotatedString.new

    list_text_rows(render_tree).each do |text_row|
      @string.append(text_row.content, text_row)
    end
  end

  def bounding_boxes_for_first(text)
    string.annotations_for_first_match(text).map(&Box.method(:from))
  end

  private

  attr_reader :string

  def list_text_rows(node)
    if node.content.empty?
      []
    elsif node.respond_to?(:children)
      node.children.flat_map(&method(:list_text_rows))
    elsif node.respond_to?(:rows)
      node.rows
    else
      []
    end
  end

  class SearchableAnnotatedString
    def initialize
      @annotations = []
      @string = ""
    end

    def append(addition, metadata)
      @annotations.push([(@string.size)...(@string.size + addition.size), metadata])

      @string.concat(addition)
    end

    def annotations_for_first_match(substring)
      match_start = string.index(substring)

      return [] if match_start.nil?

      match_end =  match_start + substring.size - 1

      overlapping(match_start, match_end)
    end

    private

    attr_reader :annotations, :string

    def overlapping(from, to)
      annotations.select { |location, _metadata|
        location.include?(from) || location.include?(to)
      }.map(&:last)
    end
  end
end
