Given(/^the HTML input:$/) do |html|
  @html_input = html
end

INTEGER_PATTERN = Transform(/^\d+$/) do |n|
  Integer(n)
end

Then(/^the resulting tree should have (#{INTEGER_PATTERN}) nodes$/) do |n|
  expect(@render_tree).not_to be_nil
  expect(tree_size(@render_tree)).to eq(n)
end
