class NodeDouble
  def initialize(nick_name:)
    @nick_name = nick_name
  end

  attr_reader :nick_name

  def clone_with(**attributes)
    NodeDouble.new(
      nick_name: attributes.fetch(:nick_name, nick_name),
    )
  end
end
