require "node_counter"
require "online_engine"
require "gosu_adapter_stubs"
require "gosu_image_calculator"
require "inspector"
require "node_lister"
require "random_uri"

def tree_size(tree)
  node_counter.call(tree)
end

def node_counter
  NodeCounter.new
end

def engine
  @engine ||= ONLINE_ENGINE.call
end

def visit_address(new_address)
  @render_tree = engine.request(
    new_address,
    viewport_width: viewport_width,
    viewport_height: viewport_height,
    text_calculator: gosu_text_calculator_stub(
      returns: [universal_width_for_any_word_or_space, universal_line_height],
    ),
    image_calculator: GosuImageCalculator.new,
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

def universal_width_for_any_word_or_space
  @universal_width_for_any_word_or_space || 50
end

def universal_line_height
  18
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

Given("a web page:") do |html|
  @address = RandomUri.new.to_s

  stub_request(:get, @address).to_return(body: html)
end

Then(/^the resulting tree should have (\d+) nodes$/) do |n|
  expect(@render_tree).not_to be_nil
  expect(tree_size(@render_tree)).to eq(n)
end

Given("a viewport only wide enough for {int} words on each row") do |words_per_row|
  words_and_spaces_per_row = (words_per_row * 2) - 1

  @viewport_width = 100
  @universal_width_for_any_word_or_space = @viewport_width / words_and_spaces_per_row
end

When(/^I request an address$/) do
  @address = "https://lwn.net/"
  visit_address(@address)
end

When(/^I render it in the browser$/) do
  visit_address(@address)
end

When("the browser renders it") do
  visit_address(@address)
end

Then(/^the browser should visit the address$/) do
  expect(a_request(:get, @address)).to have_been_made.once
end

Then(/^the browser should render the web page$/) do
  page_displays_heading("Welcome to LWN.net")
  page_displays_image(
    "https://static.lwn.net/images/logo/barepenguin-70.png",
    width: 70,
    height: 81,
  )
  page_displays_link("/op/AuthorGuide.lwn", "Write for us")
end

Then(/^each element appears to the right of its predecessor$/) do
  elements_are_positioned_left_to_right
end

Then(/^each element appears below its predecessor$/) do
  elements_are_positioned_on_their_own_rows
end

Then(/^the elements appear over four rows$/) do
  elements_are_positioned_over_four_rows
end

Then("their parent fits them all horizontically and vertically") do
  root_node_is_at_least_as_wide_as_all_of_its_children
  root_node_is_at_least_as_tall_as_all_of_its_children
end

Then("the text is wrapped into {int} rows of") do |number_of_rows, rows_text_with_newlines|
  rows_texts = rows_text_with_newlines.split("\n")

  text_node = page.find_single_node_with_text(rows_texts.first)

  expect(text_node.rows.size).to eq(number_of_rows)

  text_node.rows.zip(rows_texts).each do |row, expected_text|
    expect(row.content).to eq(expected_text)
  end
end

Then("the whole page reads") do |whole_page_text|
  expect(@render_tree.content).to eq(whole_page_text)
end
