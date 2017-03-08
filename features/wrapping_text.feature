Feature: wrapping text

  Scenario: wrapping a long single piece of text
    Given the HTML input:
      """
      <p>
        The web-development community was briefly thrown into chaos in late March when a lone Node.js developer suddenly unpublished a short but widely used package from the Node Package Manager (npm) repository. The events leading up to that developer's withdrawal are controversial in their own right, but the chaotic effects raise even more serious questions for the Node.js and npm user communities.
      </p>
      """
    When I render it in the browser
    Then the text is wrapped at the edge of the viewport
