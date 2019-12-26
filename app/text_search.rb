class TextSearch
  def initialize(render_tree)
    @string = SearchableAnnotatedString.new

    list_text_nodes(render_tree).each do |text_row|
      @string.append(text_row.content, text_row)
    end
  end

  def bounding_boxes_for_first(text)
    string.first_match(text).flat_map { |location, text_node|
      text_node.bounding_boxes_for_substring(location)
    }
  end

  private

  attr_reader :string

  def list_text_nodes(node)
    if node.content.empty?
      []
    elsif node.respond_to?(:children)
      node.children.flat_map(&method(:list_text_nodes))
    elsif node.respond_to?(:rows)
      [node]
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

    def first_match(substring)
      match_start = string.index(substring)

      return [] if match_start.nil?

      match_end =  match_start + substring.size - 1

      overlapping(match_start, match_end).map { |location, metadata|
        [node_local_location(location, match_start, match_end), metadata]
      }
    end

    private

    attr_reader :annotations, :string

    def overlapping(from, to)
      annotations.select { |location, _metadata|
        location.include?(from) || location.include?(to)
      }
    end

    def node_local_location(location, from, to)
      location_array = location.to_a

      local_from = location_array.index(from) || 0
      local_to = location_array.index(to) || location_array.size - 1

      local_from..local_to
    end
  end
end
