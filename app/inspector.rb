class Inspector
  def initialize(render_tree)
    @render_tree = render_tree
  end

  def find_nodes_with_text(text)
    deepest_matches(render_tree, text)
  end

  private

  def deepest_matches(parent_node, text)
    return [] unless parent_node.content.include?(text)

    matching_children = parent_node.children
      .flat_map { |child|
        deepest_matches(child, text)
      }
      .compact

    return matching_children unless matching_children.empty?

    [parent_node]
  end

  attr_reader :render_tree
end
