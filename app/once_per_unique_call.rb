class OncePerUniqueCall
  def initialize(callable)
    @callable = callable
    @arguments_history = []
  end

  def call(*arguments)
    return if arguments_history.include?(arguments)

    arguments_history.push(arguments)
    callable.call(*arguments)
  end

  private

  attr_reader :arguments_history, :callable
end
