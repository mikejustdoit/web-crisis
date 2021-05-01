Feature: wrapping text

  Scenario: wrapping a long text node
    Given a web page:
      """
      <p>briefly thrown into chaos</p>
      """
    And a maximum of 2 words can fit across the viewport
    When I render the page in the browser
    Then the text appears over two rows
      | briefly thrown |
      | into chaos     |
    And the whole thing still reads exactly "briefly thrown into chaos"
