require "block_level_element"
require "box"
require "element"
require "inline_element"

def build_block_level_element(box: Box.new, children: [])
  BlockLevelElement.new(
    Element.new(
      box: box,
      children: children,
    )
  )
end

def build_inline_element(box: Box.new, children: [])
  InlineElement.new(
    Element.new(
      box: box,
      children: children,
    )
  )
end
