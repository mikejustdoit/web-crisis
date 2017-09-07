require "block_level_element"
require "element"
require "inline_element"
require "text"

class UnrecognisedNodeType < TypeError; end

ELEMENTS = [BlockLevelElement, Element, InlineElement]

INLINE_NODES = [InlineElement, Text]
