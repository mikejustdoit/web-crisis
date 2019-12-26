require "text_search"

class Inspector
  class TooManyMatchesFound < TypeError; end
  class NotEnoughMatchesFound < TypeError; end

  def initialize(render_tree)
    @render_tree = render_tree
  end

  def bounding_boxes_for_first(text)
    boxes = TextSearch.new(render_tree).bounding_boxes_for_first(text)

    raise NotEnoughMatchesFound.new(text) if boxes.empty?

    boxes
  end

  def find_single_image(src)
    matches = all_src_matches(render_tree, src)

    raise TooManyMatchesFound.new(src) if matches.size > 1

    raise NotEnoughMatchesFound.new(src) if matches.size < 1

    matches.first
  end

  def find_single_link(href)
    matches = all_href_matches(render_tree, href)

    raise TooManyMatchesFound.new(href) if matches.size > 1

    raise NotEnoughMatchesFound.new(href) if matches.size < 1

    matches.first
  end

  private

  attr_reader :render_tree

  def all_src_matches(parent_node, src)
    return [parent_node] if parent_node.respond_to?(:src) && parent_node.src == src

    return [] unless parent_node.respond_to?(:children)

    parent_node.children.flat_map { |child| all_src_matches(child, src) }.compact
  end

  def all_href_matches(parent_node, href)
    if parent_node.respond_to?(:href) && parent_node.href == href
      return [parent_node]
    end

    return [] unless parent_node.respond_to?(:children)

    parent_node.children.flat_map { |child| all_href_matches(child, href) }.compact
  end
end
