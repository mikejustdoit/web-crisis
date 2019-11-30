Given(/^the HTML input:?$/) do |html|
  @html_input = html
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
  render_in_browser(@html_input)
end

When("the browser renders it") do
  render_in_browser(@html_input)
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
