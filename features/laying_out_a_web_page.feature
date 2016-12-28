Feature: laying out a web page

  Scenario: inline nodes
    Given the HTML input:
      """
      <div>
        <a>Your</a> <a>ad</a> <a>here</a>.
      </div>
      """
    When I render it in the browser
    Then each element appears to the right of its predecessor
    And their parent fits them all widthwise
