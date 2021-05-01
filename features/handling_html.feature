Feature: rendering HTML

  Scenario: handling renderable element types
    Given a web page:
      """
      <html><body><body><html>
      """
    When I render it in the browser
    Then the resulting tree has 2 nodes

  Scenario: handling unrenderable element types
    Given a web page:
      """
      <html><head></head><body><body><html>
      """
    When I render it in the browser
    Then the resulting tree has 2 nodes
