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
    And the downloaded PDF "dta_information_release.pdf" should contain "Maya Example"
    And the downloaded PDF "dta_information_release.pdf" should contain "123456789"
    And the downloaded PDF "dta_information_release.pdf" should contain "Example Community Food Pantry"
    And the downloaded PDF "dta_information_release.pdf" should contain "Suite 4, Boston, MA 02110"
    And the downloaded PDF "dta_information_release.pdf" should contain "Client/Applicant Signature:"
    And the downloaded PDF "dta_information_release.pdf" should not contain "None"

  @ssn_edit
  Scenario: Lee uses a four-digit SSN and then switches to an Agency ID
    Given I start the interview at "permission_to_access_dta_client_information.yml"
    And I use a narrow phone viewport
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
    Then I should see the phrase "Enter exactly four digits"
    When I get to "dta download" with this data:
      | var | value | trigger |
      | dta_identifier_kind | ssn | |
      | ssn_last_four | 0123 | |
      | recipient_name | Jordan Example | |
      | recipient_address | 200 Example Road, Apartment 12, Springfield, MA 01103 | |
      | recipient_phone | 4135550100 | |
    And I download "dta_information_release.pdf"
    Then the downloaded PDF "dta_information_release.pdf" should contain "0123"
    When I follow the review link containing "Edit answers"
    And I follow the review link containing "Case identification:"
    And I get to "dta review" with this data:
      | var | value | trigger |
      | dta_identifier_kind | agency | |
      | dta_agency_id | 987654321 | |
    And I continue
    Then the question id should be "dta download"
    When I download a fresh copy of "dta_information_release.pdf"
    Then the downloaded PDF "dta_information_release.pdf" should contain "987654321"
    And the downloaded PDF "dta_information_release.pdf" should not contain "0123"
    And the downloaded PDF "dta_information_release.pdf" should contain "Jordan Example"
    And the interview fits the phone width
    And I take a screenshot named "phone-download"

  @scope
  Scenario: A client who wants help signing applications gets the correct alternative
    Given I start the interview at "permission_to_access_dta_client_information.yml"
    And the maximum seconds for each step is 90
    When I get to "dta other help" with this data:
      | var | value | trigger |
      | acknowledged_information_use | True | |
      | permission_purpose | representative | |
    Then I should see the phrase "Choose the right kind of help"
    And I should see the link "DTA authorized representative interview"
    And I should not see the phrase "Print, sign, and send your DTA consent"
