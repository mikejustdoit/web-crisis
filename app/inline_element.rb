class InlineElement < SimpleDelegator
  def clone_with(**attributes)
    InlineElement.new(
      __getobj__.clone_with(**attributes),
    )
  end
end
