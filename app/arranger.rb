require "children_consecutor"
require "children_measurer"
require "node_types"
require "text_wrapper"

class Arranger
  def initialize(text_width_calculator:, viewport_width:, **)
    @text_width_calculator = text_width_calculator
    @viewport_width = viewport_width
  end

  def call(node)
    case node
    when *ELEMENTS
      visit_element(node)
    when Text
      visit_text(node)
    end
  end

  private

  attr_reader :text_width_calculator, :viewport_width

  def visit_element(positioned_node)
    arranged_children = arrange_children(positioned_node.children)

    inner_width, inner_height = measure_children_dimensions(arranged_children)

    positioned_node.clone_with(
      children: arranged_children,
      width: inner_width,
      height: inner_height,
    )
  end

  def visit_text(positioned_node)
    TextWrapper.new(positioned_node, text_width_calculator: text_width_calculator)
      .call(right_limit: viewport_width)
  end

  def arrange_children(children)
    return [] if children.empty?

    ChildrenConsecutor.new(children).as_groups
      .inject([]) { |arranged_children, group|
        preceding_sibling = arranged_children.last

        if preceding_sibling.nil?
          arranged_children + arrange_group(group, y: 0)
        else
          arranged_children + arrange_group(group, y: preceding_sibling.bottom)
        end
      }
  end

  def arrange_group(group, y:)
    group.inject([]) { |arranged_children, child|
      preceding_sibling = arranged_children.last

      if preceding_sibling.nil?
        positioned_child = position_on_new_row(child, y: y)
      else
        positioned_child = position_on_existing_row(
          child,
          preceding_sibling: preceding_sibling,
        )
      end

      arranged_children + [*call(positioned_child)]
    }
  end

  def position_on_new_row(child, y:)
    child.clone_with(
      x: 0,
      y: y,
    )
  end

  def position_on_existing_row(child, preceding_sibling:)
    child.clone_with(
      x: preceding_sibling.right,
      y: preceding_sibling.y,
    )
  end

  def measure_children_dimensions(children)
    ChildrenMeasurer.new.call(children)
  end
end
