require "node_types"

class ChildrenConsecutor
  def initialize(children)
    @children = children
  end

  def as_groups
    return [] if children.empty?

    first_group = [children.first]

    all_children_but_the_first
      .inject([first_group]) { |preceding_groups, child|
        preceding_sibling = preceding_groups.last.last

        if INLINE_NODES.include?(preceding_sibling.class) &&
          INLINE_NODES.include?(child.class)
            append_to_last_group(child, preceding_groups)
        else
          add_to_new_group(child, preceding_groups)
        end
      }
  end

  private

  attr_reader :children

  def append_to_last_group(child, preceding_groups)
    preceding_groups[0...-1] + [preceding_groups.last + [child]]
  end

  def add_to_new_group(child, preceding_groups)
    preceding_groups + [[child]]
  end

  def all_children_but_the_first
    children.drop(1)
  end
end
