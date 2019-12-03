class VisitorPipeline
  def initialize(visitor_factories)
    @visitor_factories = visitor_factories
  end

  def visit(tree, **application_context)
    visitor_factories
      .map { |factory|
        factory.call(**application_context)
      }
      .reduce(tree) { |root_node, visitor|
        visitor.call(root_node)
      }
  end

  private

  attr_reader :visitor_factories
end
