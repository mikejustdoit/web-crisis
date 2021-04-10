def parsed_text_node(content)
  double(
    :parsed_text_element,
    name: "text",
    content: content,
  )
end
