Feature: rendering HTML

  Scenario: handling renderable element types
    Given the HTML input:
      """
      <html><body><body><html>
      """
    When I render it in the browser
    Then the resulting tree should have 2 nodes

  Scenario: handling unrenderable element types
    Given the HTML input:
      """
      <html><head></head><body><body><html>
      """
    When I render it in the browser
    Then the resulting tree should have 2 nodes
