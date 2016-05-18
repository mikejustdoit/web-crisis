def visitor_double
  visitor = double(:visitor_double)

  allow(visitor).to receive(:visit_element) { |node| node }
  allow(visitor).to receive(:visit_text) { |node| node }

  visitor
end
