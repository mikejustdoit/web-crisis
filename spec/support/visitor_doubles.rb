def drawing_visitor_double
  double(:drawing_visitor,
    :draw_element => nil,
    :draw_text => nil,
  )
end

def layout_visitor_double
  double(:layout_visitor,
    :layout_element => nil,
    :layout_text => nil,
  )
end
