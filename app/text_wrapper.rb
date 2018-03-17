require "box"
require "build_text"
require "text"

class TextWrapper
  def initialize(text_node, text_width_calculator:)
    @text_node = text_node
    @text_width_calculator = text_width_calculator
  end

  def call(right_limit:)
    words
      .inject([]) { |rows, next_word|
        current_row = rows.last

        if current_row.nil?
          [add_to_new_row(next_word, y: text_node.y)]
        else
          row_with_word = current_row + space + next_word

          if row_with_word.right > right_limit
            rows + [
              add_to_new_row(
                zero_width_space + next_word,
                y: current_row.bottom,
              )
            ]
          else
            rows[0...-1] + [row_with_word]
          end
        end
      }
  end

  private

  attr_reader :text_node, :text_width_calculator

  def words
    text_node.content.split(" ")
      .map { |word_text| node_from(word_text) }
  end

  def add_to_new_row(word, y:)
    word.clone_with(
      x: 0,
      y: y,
    )
  end

  def node_from(word)
    BuildText.new.call(
      box: Box.new(
        x: 0,
        y: 0,
        width: text_width_calculator.call(word),
        height: text_node.height,
      ),
      content: word,
    )
  end

  def space
    @space ||= node_from(" ")
  end

  def zero_width_space
    BuildText.new.call(
      box: Box.new(
        x: 0,
        y: 0,
        width: 0,
        height: text_node.height,
      ),
      content: " ",
    )
  end
end
