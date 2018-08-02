require "engine"
require "fetcher"
require "gosu_adapter_stubs"
require "inspector"
require "layout_visitors"
require "offline_html_fetcher"
require "parser"

module EngineWorld
  def engine
    @engine ||= Engine.new(
      fetcher: Fetcher.new,
      layout_pipeline: LAYOUT_VISITORS,
      parser: Parser.new(logger: ->(_) {}),
    )
  end

  def visit_address(new_address)
    @render_tree = engine.request(
      new_address,
      viewport_width,
      viewport_height,
      gosu_text_width_calculator_stub(returns: 50),
    )
  end

  def viewport_width
    640
  end

  def viewport_height
    480
  end

  def page_displays_heading(text)
    expect_text_to_be_at_top(text)
  end

  def expect_text_to_be_at_top(text)
    node = page.find_nodes_with_text(text).first

    expect(node.y).to be < viewport_height / 2
  end

  def page_displays_image(image_address, width:, height:)
    image = page.find_single_image(image_address)

    expect(image.width).to eq(width)
    expect(image.height).to eq(height)
  end

  def page
    Inspector.new(@render_tree)
  end
end

World(EngineWorld)

module OfflineHtmlWorld
  def offline_html_engine(html_input)
    Engine.new(
      fetcher: OfflineHtmlFetcher.new(html_input),
      layout_pipeline: LAYOUT_VISITORS,
      parser: Parser.new(logger: ->(_) {}),
    )
  end

  def render_in_browser(html_input)
    @render_tree = offline_html_engine(html_input)
      .request(
        "https://dummy.address",
        viewport_width,
        viewport_height,
        gosu_text_width_calculator_stub(returns: 50),
      )
  end

  def elements_are_positioned_left_to_right
    first_node = page.find_nodes_with_text("Your").first
    second_node = page.find_nodes_with_text("ad").first
    third_node = page.find_nodes_with_text("here").first

    expect(second_node.x).to be >= first_node.right
    expect(third_node.x).to be >= second_node.right
  end

  def elements_are_positioned_on_their_own_rows
    first_node = page.find_nodes_with_text("Firstly.").first
    second_node = page.find_nodes_with_text("Secondly.").first
    third_node = page.find_nodes_with_text("Lastly.").first

    expect(second_node.y).to be >= first_node.bottom
    expect(third_node.y).to be >= second_node.bottom
  end

  def elements_are_positioned_over_four_rows
    first_node = page.find_nodes_with_text("Firstly.").first

    second_node = page.find_nodes_with_text("Secondly.").first

    third_node = page.find_nodes_with_text("Your").first
    fourth_node = page.find_nodes_with_text("ad").first
    fifth_node = page.find_nodes_with_text("here").first

    last_node = page.find_nodes_with_text("Lastly.").first

    expect(second_node.y).to be >= first_node.bottom

    expect(third_node.y).to be >= second_node.bottom
    expect(fourth_node.y).to eq(third_node.y)
    expect(fifth_node.y).to eq(third_node.y)

    expect(last_node.y).to be >= fifth_node.bottom
  end

  def root_node_is_at_least_as_wide_as_all_of_its_chilren
    parent_node = @render_tree

    first_child_node = page.find_nodes_with_text("Your").first
    second_child_node = page.find_nodes_with_text("ad").first
    third_child_node = page.find_nodes_with_text("here").first

    expect(parent_node.width).to be >=
      first_child_node.width + second_child_node.width + third_child_node.width
  end

  def root_node_is_at_least_as_tall_as_all_of_its_chilren
    parent_node = @render_tree

    first_child_node = page.find_nodes_with_text("Firstly.").first
    second_child_node = page.find_nodes_with_text("Secondly.").first
    third_child_node = page.find_nodes_with_text("Lastly.").first

    expect(parent_node.height).to be >=
      first_child_node.height + second_child_node.height + third_child_node.height
  end

  def root_node_is_about_as_tall_as_four_rows
    parent_node = @render_tree

    first_node = page.find_nodes_with_text("Firstly.").first

    second_node = page.find_nodes_with_text("Secondly.").first

    third_node = page.find_nodes_with_text("Your").first
    fourth_node = page.find_nodes_with_text("ad").first
    fifth_node = page.find_nodes_with_text("here").first

    last_node = page.find_nodes_with_text("Lastly.").first


    height_of_all_four_rows =
      first_node.height + second_node.height +
      third_node.height + last_node.height

    height_of_all_children =
      first_node.height + second_node.height +
      third_node.height + fourth_node.height +
      fifth_node.height + last_node.height

    expect(parent_node.height).to be >= height_of_all_four_rows
    expect(parent_node.height).to be < height_of_all_children
  end

  def root_node_is_about_as_wide_as_its_longest_row_of_chilren
    parent_node = @render_tree

    first_child_node = page.find_nodes_with_text("Firstly.").first

    second_child_node = page.find_nodes_with_text("Secondly.").first

    third_child_node = page.find_nodes_with_text("Your").first
    fourth_child_node = page.find_nodes_with_text("ad").first
    fifth_child_node = page.find_nodes_with_text("here").first

    last_child_node = page.find_nodes_with_text("Lastly.").first

    width_of_longest_row =
      third_child_node.width + fourth_child_node.width + fifth_child_node.width

    width_of_all_children =
      first_child_node.width + second_child_node.width +
      third_child_node.width + fourth_child_node.width +
      fifth_child_node.width + last_child_node.width

    expect(parent_node.width).to be >= width_of_longest_row
    expect(parent_node.width).to be < width_of_all_children
  end

  def text_is_split_across_multiple_nodes
    entire_text_content = "The web-development community was briefly thrown into chaos in late March when a lone Node.js developer suddenly unpublished a short but widely used package from the Node Package Manager (npm) repository. The events leading up to that developer's withdrawal are controversial in their own right, but the chaotic effects raise even more serious questions for the Node.js and npm user communities."
    text_node = page.find_single_node_with_text(entire_text_content)
    expect(text_node.rows.size).to be > 1
  end

  def text_width_is_within_viewport_width
    first_text = page.find_nodes_with_text("The web-development community").first
    expect(first_text.right).to be <= viewport_width
  end
end

World(OfflineHtmlWorld)
