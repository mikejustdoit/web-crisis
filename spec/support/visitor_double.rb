def visitor_double
  visitor = double(:visitor_double)

  allow(visitor).to receive(:call) { |node| node }

  visitor
end
