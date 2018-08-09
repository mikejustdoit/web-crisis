When(/^I request an address$/) do
  @address = "https://lwn.net/"
  visit_address(@address)
end

When(/^I render it in the browser$/) do
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

Then(/^the text is wrapped at the edge of the viewport$/) do
  text_is_split_across_multiple_nodes
  text_width_is_within_viewport_width
end
