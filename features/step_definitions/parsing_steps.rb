Given(/^the HTML input:$/) do |html|
  @html_input = html
end

When(/^I run the parser$/) do
  @tree = parse_html(@html_input)
end

INTEGER_PATTERN = Transform(/^\d+$/) do |n|
  Integer(n)
end

Then(/^the resulting tree should have (#{INTEGER_PATTERN}) nodes$/) do |n|
  expect(tree_size(@tree)).to eq(n)
end
