require "box"
require "text_row"

class TextWrapper
  def initialize(text_node, text_calculator:, maximum_bounds:)
    @text_node = text_node
    @text_calculator = text_calculator
    @maximum_bounds = maximum_bounds
  end

  def call
    text_node.clone_with(
      rows: words
        .inject([]) { |rows, next_word|
          current_row = rows.last

          if current_row.nil?
            [create_first_row(next_word)]
          else
            row_with_word = current_row + space + next_word

            if row_with_word.right > maximum_bounds.right
              rows + [
                add_to_new_row(next_word, y: current_row.bottom)
              ]
            else
              rows[0...-1] + [row_with_word]
            end
          end
        },
    )
  end

  private

  attr_reader :text_node, :text_calculator, :maximum_bounds

  def words
    text_node.content.split(" ")
      .map { |word_text| node_from(word_text) }
  end

  def create_first_row(word)
    word.clone_with(
      x: 0,
      y: 0,
    )
  end

  def add_to_new_row(word, y:)
    word.clone_with(
      x: maximum_bounds.x,
      y: y,
    )
  end

  def node_from(word)
    width, height = text_calculator.call(word)

    TextRow.new(
      box: Box.new(
        x: 0,
        y: 0,
        width: width,
        height: height,
      ),
      content: word,
    )
  end

  def space
    @space ||= node_from(" ")
  end
end
