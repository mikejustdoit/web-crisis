def drawing_visitor_double
  double(:drawing_visitor,
    :visit_element => nil,
    :visit_text => nil,
  )
end

def layout_visitor_double
  double(:layout_visitor,
    :visit_element => nil,
    :visit_text => nil,
  )
end
