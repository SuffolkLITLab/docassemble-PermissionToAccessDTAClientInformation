Feature: Give a trusted person or organization permission to discuss DTA cases

  @agency
  Scenario: Maya authorizes a helping organization using her Agency ID
    Given I start the interview at "permission_to_access_dta_client_information.yml"
    And the maximum seconds for each step is 90
    When I get to "dta download" with this data:
      | var | value | trigger |
      | acknowledged_information_use | True | |
      | permission_purpose | information | |
      | client_name | Maya Example | |
      | client_birthdate | 01/02/1980 | |
      | dta_identifier_kind | agency | |
      | dta_agency_id | 123456789 | |
      | recipient_name | Example Community Food Pantry | |
      | recipient_address | 100 Example Street, Suite 4, Boston, MA 02110 | |
      | recipient_phone | | |
    Then I should see the phrase "This form has not been sent to DTA."
    And I download "dta_information_release.pdf"
    When I tap the "#daquestion a[data-embaction='eyJhY3Rpb24iOiAiZHRhX3JldmlldyIsICJhcmd1bWVudHMiOiB7fX0']" element
    And I tap the "#daquestion a[data-embaction='eyJhY3Rpb24iOiAicGVybWlzc2lvbl9wdXJwb3NlIiwgImFyZ3VtZW50cyI6IHt9fQ']" element
    And I get to "dta review" with this data:
      | var | value | trigger |
      | permission_purpose | representative | |
    Then I should see the phrase "Sign forms for me or use my benefits"
    When I continue
    Then the question id should be "dta other help"
    And I should see the phrase "TAFDC, or EAEDC"

  @ssn_edit
  Scenario: Lee uses a four-digit SSN and then switches to an Agency ID
    Given I start the interview at "permission_to_access_dta_client_information.yml"
    And the maximum seconds for each step is 90
    When I get to "dta identifier" with this data:
      | var | value | trigger |
      | acknowledged_information_use | True | |
      | permission_purpose | information | |
      | client_name | Lee Example | |
      | client_birthdate | 03/04/1975 | |
    When I set the variable "dta_identifier_kind" to "ssn"
    And I set the variable "ssn_last_four" to "abcd"
    And I cannot continue
    Then I should see the phrase "Enter four numbers"
    When I get to "dta download" with this data:
      | var | value | trigger |
      | dta_identifier_kind | ssn | |
      | ssn_last_four | 0123 | |
      | recipient_name | Jordan Example | |
      | recipient_address | 200 Example Road, Apartment 12, Springfield, MA 01103 | |
      | recipient_phone | 4135550100 | |
    Then the text in the JSON variable "ssn_last_four" should be
      """
      0123
      """
    When I tap the "#daquestion a[data-embaction='eyJhY3Rpb24iOiAiZHRhX3JldmlldyIsICJhcmd1bWVudHMiOiB7fX0']" element
    And I tap the "#daquestion a[data-embaction='eyJhY3Rpb24iOiAiZHRhX2lkZW50aWZpZXJfa2luZCIsICJhcmd1bWVudHMiOiB7fX0']" element
    And I get to "dta review" with this data:
      | var | value | trigger |
      | dta_identifier_kind | agency | |
      | dta_agency_id | 987654321 | |
    And I continue
    Then the question id should be "dta download"
    And the text in the JSON variable "dta_identifier_kind" should be
      """
      agency
      """
    And the text in the JSON variable "dta_agency_id" should be
      """
      987654321
      """
    And I download "dta_information_release.pdf"
    And I take a screenshot named "download-after-edit"

  @scope
  Scenario: A client who wants help signing applications gets the correct alternative
    Given I start the interview at "permission_to_access_dta_client_information.yml"
    And the maximum seconds for each step is 90
    When I get to "dta other help" with this data:
      | var | value | trigger |
      | acknowledged_information_use | True | |
      | permission_purpose | representative | |
    Then I should see the phrase "Choose the right kind of help"
    And I should see the link "Choose someone to help with your benefits"
    And I should not see the phrase "Print, sign, and send your DTA form"
