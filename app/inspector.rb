require "box"
require "text_search"

class Inspector
  class TooManyMatchesFound < TypeError; end
  class NotEnoughMatchesFound < TypeError; end

  def initialize(render_tree)
    @render_tree = render_tree
  end

  def bounding_boxes_for_first(text)
    boxes = TextSearch.new(render_tree).find_owners_of(text)
      .map { |text_row|
        Box.new(
          x: text_row.x,
          y: text_row.y,
          width: text_row.width,
          height: text_row.height,
        )
      }

    raise NotEnoughMatchesFound.new(text) if boxes.empty?

    boxes
  end

  def find_nodes_with_text(text)
    deepest_text_matches(render_tree, text)
  end

  def find_single_element_with_text(text)
    matches = deepest_text_matching_elements(render_tree, text)

    raise TooManyMatchesFound.new(text) if matches.size > 1

    raise NotEnoughMatchesFound.new(text) if matches.size < 1

    matches.first
  end

  def find_single_image(src)
    matches = all_src_matches(render_tree, src)

    raise TooManyMatchesFound.new(src) if matches.size > 1

    raise NotEnoughMatchesFound.new(src) if matches.size < 1

    matches.first
  end

  private

  attr_reader :render_tree

  def deepest_text_matches(parent_node, text)
    return [] unless parent_node.content.include?(text)

    return [parent_node] unless parent_node.respond_to?(:children)

    matching_children = parent_node.children
      .flat_map { |child|
        deepest_text_matches(child, text)
      }
      .compact

    return matching_children unless matching_children.empty?

    [parent_node]
  end

  def deepest_text_matching_elements(parent_node, text)
    return [] if parent_node.respond_to?(:rows)

    return [] unless parent_node.content.include?(text)

    return [] unless parent_node.respond_to?(:children)

    matching_children = parent_node.children
      .flat_map { |child|
        deepest_text_matching_elements(child, text)
      }
      .compact

    return matching_children unless matching_children.empty?

    [parent_node]
  end

  def all_src_matches(parent_node, src)
    return [parent_node] if parent_node.respond_to?(:src) && parent_node.src == src

    return [] unless parent_node.respond_to?(:children)

    parent_node.children.flat_map { |child| all_src_matches(child, src) }.compact
  end
end
