require "children_consecutor"
require "children_measurer"
require "node_types"

class Arranger
  def initialize(**_); end

  def call(node)
    case node
    when *ELEMENTS
      visit_element(node)
    when Text
      node
    end
  end

  private

  def visit_element(node)
    children_with_positioned_children = node.children.map { |child| call(child) }

    positioned_children = position_children(children_with_positioned_children)

    inner_width, inner_height = measure_children_dimensions(positioned_children)

    node.clone_with(
      children: positioned_children,
      width: inner_width,
      height: inner_height,
    )
  end

  def position_children(children)
    return [] if children.empty?

    ChildrenConsecutor.new(children).as_groups
      .inject([]) { |arranged_children, group|
        preceding_sibling = arranged_children.last

        if preceding_sibling.nil?
          arranged_children + position_group(group, y: 0)
        else
          arranged_children + position_group(group, y: preceding_sibling.bottom)
        end
      }
  end

  def position_group(group, y:)
    group.inject([]) { |positioned_children, child|
      preceding_sibling = positioned_children.last

      if preceding_sibling.nil?
        positioned_children + [position_on_new_row(child, y: y)]
      else
        positioned_children +
          [position_on_existing_row(child, preceding_sibling: preceding_sibling)]
      end
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
