require "engine"
require "fetcher"
require "gosu_adapter_stubs"
require "gosu_image_dimensions_calculator"
require "image_store"
require "inspector"
require "layout_visitors"
require "local_file_image_store"
require "node_lister"
require "offline_html_fetcher"
require "parser"

module EngineWorld
  def engine
    @engine ||= Engine.new(
      fetcher: Fetcher.new,
      image_store_factory: -> (**) { ImageStore.new(fetcher: Fetcher.new) },
      layout_pipeline: LAYOUT_VISITORS,
      parser: Parser.new,
    )
  end

  def visit_address(new_address)
    @render_tree = engine.request(
      new_address,
      viewport_width: viewport_width,
      viewport_height: viewport_height,
      text_width_calculator: gosu_text_width_calculator_stub(returns: 50),
      image_dimensions_calculator: GosuImageDimensionsCalculator.new,
    )
  end

  def viewport_width
    @viewport_width || 640
  end

  def viewport_height
    480
  end

  def page_displays_heading(text)
    node = page.find_nodes_with_text(text).first

    expect(node.y).to be < viewport_height
  end

  def page_displays_image(image_address, width:, height:)
    image = page.find_single_image(image_address)

    expect(image.width).to eq(width)
    expect(image.height).to eq(height)
  end

  def page_displays_link(uri, content)
    element = page.find_single_element_with_text(content)
    child_text_nodes = page.find_nodes_with_text(content)

    expect(element.href).to eq(uri)
    expect(child_text_nodes.map(&:colour).uniq).to eq([:blue])
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
      image_store_factory: LocalFileImageStore.method(:new),
      layout_pipeline: LAYOUT_VISITORS,
      parser: Parser.new,
    )
  end

  def render_in_browser(html_input)
    @render_tree = offline_html_engine(html_input)
      .request(
        "https://dummy.address",
        viewport_width: viewport_width,
        viewport_height: viewport_height,
        text_width_calculator: gosu_text_width_calculator_stub(
          returns: universal_width_for_any_word_or_space,
        ),
        image_dimensions_calculator: GosuImageDimensionsCalculator.new,
      )
  end

  def universal_width_for_any_word_or_space
    @universal_width_for_any_word_or_space || 50
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

  def root_node_is_at_least_as_wide_as_all_of_its_children
    parent_node = @render_tree

    all_descendants = NodeLister.new.call(parent_node) - [parent_node]

    furthest_left = all_descendants.map(&:x).min
    furthest_right = all_descendants.map(&:right).max

    expect(parent_node.x).to be <= furthest_left
    expect(parent_node.right).to be >= furthest_right
  end

  def root_node_is_at_least_as_tall_as_all_of_its_children
    parent_node = @render_tree

    all_descendants = NodeLister.new.call(parent_node) - [parent_node]

    furthest_top = all_descendants.map(&:y).min
    furthest_bottom = all_descendants.map(&:bottom).max

    expect(parent_node.y).to be <= furthest_top
    expect(parent_node.bottom).to be >= furthest_bottom
  end
end

World(OfflineHtmlWorld)
