Feature: Clicking links

  Scenario: Clicking a link with an absolute URI
    Given a web page:
      """
      Let me
      <a href='https://en.wikipedia.org/wiki/Hyperlink'>Wikipedia that</a>
      for you
      """
    And I render it in the browser
    When I click on "Wikipedia that"
    Then the browser visits "https://en.wikipedia.org/wiki/Hyperlink"
    And the browser renders the heading "Hyperlink"

  Scenario: Clicking a relative link
    Given I'm on the page "https://en.wikipedia.org/wiki/Hyperlink"
    When I click on "computing"
    Then the browser visits "https://en.wikipedia.org/wiki/Computing"
    And the browser renders the heading "Computing"
