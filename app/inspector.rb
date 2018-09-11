class Inspector
  class TooManyMatchesFound < TypeError; end
  class NotEnoughMatchesFound < TypeError; end

  def initialize(render_tree)
    @render_tree = render_tree
  end

  def find_nodes_with_text(text)
    deepest_text_matches(render_tree, text)
  end

  def find_single_node_with_text(text)
    matches = find_nodes_with_text(text)

    raise TooManyMatchesFound.new if matches.size > 1

    raise NotEnoughMatchesFound.new if matches.size < 1

    matches.first
  end

  def find_single_element_with_text(text)
    matches = deepest_text_matching_elements(render_tree, text)

    raise TooManyMatchesFound.new if matches.size > 1

    raise NotEnoughMatchesFound.new if matches.size < 1

    matches.first
  end

  def find_single_image(src)
    matches = all_src_matches(render_tree, src)

    raise TooManyMatchesFound.new if matches.size > 1

    raise NotEnoughMatchesFound.new if matches.size < 1

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
