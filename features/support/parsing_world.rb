require "parser"

module ParsingWorld
  def parse_html(html)
    parser.call(html)
  end

  def parser
    Parser.new
  end
end

World(ParsingWorld)
