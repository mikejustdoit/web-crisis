class LayoutPipeline
  def initialize(layout_visitor_factories)
    @layout_visitor_factories = layout_visitor_factories
  end

  def visit(tree, **viewport_dimensions)
    layout_visitor_factories
      .map { |factory|
        factory.call(**viewport_dimensions)
      }
      .reduce(tree) { |root_node, visitor|
        visitor.call(root_node)
      }
  end

  private

  attr_reader :layout_visitor_factories
end
