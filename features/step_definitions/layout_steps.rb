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
