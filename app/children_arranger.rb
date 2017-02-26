require "children_consecutor"
require "node_types"

class ChildrenArranger
  def initialize(children)
    @children = children
  end

  def call
    return [] if children.empty?

    consecutive_groups.inject([]) { |arranged_children, group|
      preceding_sibling = arranged_children.last

      if preceding_sibling.nil?
        arranged_children + position_group(group, y: 0)
      else
        arranged_children + position_group(group, y: preceding_sibling.bottom)
      end
    }
  end

  private

  attr_reader :children

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

  def consecutive_groups
    ChildrenConsecutor.new(children).as_groups
  end
end
