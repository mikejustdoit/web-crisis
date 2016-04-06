Feature: parsing HTML

  Scenario: handling renderable element types
    Given the HTML input:
      """
      <html><body><body><html>
      """
    When I run the parser
    Then the resulting tree should have 2 nodes

  @wip
  Scenario: handling unrenderable element types
    Given the HTML input:
      """
      <html><head></head><body><body><html>
      """
    When I run the parser
    Then the resulting tree should have 2 nodes
