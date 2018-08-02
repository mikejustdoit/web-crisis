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

    raise TooManyMatchesFound if matches.size > 1

    raise NotEnoughMatchesFound if matches.size < 1

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
end
