Feature: rendering images

  Scenario: handling unsupported image types
    Given an "image/svg+xml" image "/svg/abc123"
    And a web page:
      """
      <html>
        <body>
          <img src='/svg/abc123'>
        </body>
      </html>
      """
    When I render the page in the browser
    Then "/svg/abc123" should fall back to the placeholder image
