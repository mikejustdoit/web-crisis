Feature: wrapping text

  Scenario: wrapping a long text node
    Given a web page:
      """
      <p>briefly thrown into chaos</p>
      """
    And a viewport only wide enough for 2 words on each row
    When the browser renders it
    Then the whole page reads
      """
      briefly thrown into chaos
      """
    And the text is wrapped into 2 rows of
      """
      briefly thrown
      into chaos
      """
