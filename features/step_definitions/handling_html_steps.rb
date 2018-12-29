Given(/^the HTML input:?$/) do |html|
  @html_input = html
end

Then(/^the resulting tree should have (\d+) nodes$/) do |n|
  expect(@render_tree).not_to be_nil
  expect(tree_size(@render_tree)).to eq(n)
end
