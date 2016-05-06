def drawing_visitor_double
  double(:drawing_visitor,
    :draw_box => nil,
    :draw_text => nil,
  )
end

def layout_visitor_double
  double(:layout_visitor,
    :layout_node => nil,
    :layout_text_node => nil,
  )
end
