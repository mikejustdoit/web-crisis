class PositionCalculator
  def initialize(**_); end

  def visit_element(node)
    new_children = node.children.first(1)
      .map { |first_child|
        first_child.accept_visit(
          first_child_position_calculator(node)
        )
      }

    new_children = node.children.drop(1)
      .inject(new_children) { |preceding_children, child|
        preceding_children + [
          child.accept_visit(
            subsequent_child_position_calculator(preceding_children.last)
          )
        ]
      }

    node.clone_with(children: new_children)
  end

  def visit_text(node)
    node
  end

  def first_child_position_calculator(parent_node)
    FirstChildPositionCalculator.new(
      decorated_visitor: self,
      parent_node: parent_node,
    )
  end

  def subsequent_child_position_calculator(preceding_sibling_node)
    SubsequentChildPositionCalculator.new(
      decorated_visitor: self,
      preceding_sibling_node: preceding_sibling_node,
    )
  end

  class FirstChildPositionCalculator
    def initialize(decorated_visitor:, parent_node:)
      @decorated_visitor = decorated_visitor
      @parent_node = parent_node
    end

    def visit_element(node)
      decorated_visitor.visit_element(
        positioned_node(node)
      )
    end

    def visit_text(node)
      decorated_visitor.visit_text(
        positioned_node(node)
      )
    end

    private

    attr_reader :decorated_visitor, :parent_node

    def positioned_node(node)
      node.clone_with(
        y: parent_node.y,
      )
    end
  end

  class SubsequentChildPositionCalculator
    def initialize(decorated_visitor:, preceding_sibling_node:)
      @decorated_visitor = decorated_visitor
      @preceding_sibling_node = preceding_sibling_node
    end

    def visit_element(node)
      decorated_visitor.visit_element(
        positioned_node(node)
      )
    end

    def visit_text(node)
      decorated_visitor.visit_text(
        positioned_node(node)
      )
    end

    private

    attr_reader :decorated_visitor, :preceding_sibling_node

    def positioned_node(node)
      node.clone_with(
        y: preceding_sibling_node.y + preceding_sibling_node.height,
      )
    end
  end
end
