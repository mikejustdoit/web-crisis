class BlockLevelElement < SimpleDelegator
  def clone_with(**attributes)
    BlockLevelElement.new(
      __getobj__.clone_with(**attributes),
    )
  end
end
