Feature: visitor fills in wizard form

  As a visitor
  I want to fill in the wizard form
  So that I can see the most suitable laptops for my needs
  
  Background:
    Given a set of super usages with usages

  Scenario: see all super usages
    Given I am on the first page of the wizard form
    When I do nothing
    Then I should see all the super usages
    And no super usages should be selected

  @javascript
  Scenario Outline: select super usages
    Given I am on the first page of the wizard form
    When I click on the "<super_usage>" super usage
    Then I should see a number of <usages_number> usages
    And I should see the usage "<usage_example>"
    But I should not see the usage "<bad_usage_example>"

    Scenarios: select documents
      | super_usage | usages_number | usage_example | bad_usage_example |
      | Bureautique | 2             | Bureautique_1 | Internet_1        |
      | Bureautique | 2             | Bureautique_2 | Internet_2        |
      | Internet    | 3             | Internet_1    | Bureautique_1     |
      | Internet    | 3             | Internet_2    | Bureautique_2     |
      | Internet    | 3             | Internet_3    | Bureautique_1     |

  @javascript
  Scenario Outline: select and deselect usages
    Given I am on the first page of the wizard form
    When I click on the "<super_usage>" super usage
    When I choose the "<usage1>" usage
    And I choose the "<usage2>" usage
    And I click on "validate usages"
    Then the "<super_usage>" super usage <should_or_should_not> be validated

    Scenarios: choose 2 distinct usages
      | super_usage | usage1        | usage2        | should_or_should_not |
      | Bureautique | Bureautique_1 | Bureautique_2 | should               |
      | Internet    | Internet_1    | Internet_2    | should               |
      | Internet    | Internet_2    | Internet_3    | should               |

    Scenarios: click on the same usage twice
      | super_usage | usage1        | usage2        | should_or_should_not |
      | Bureautique | Bureautique_1 | Bureautique_1 | should_not           |

    Scenarios: click on one usage and cancel
      | super_usage | usage1        | usage2 | should_or_should_not |
      | Bureautique | Bureautique_1 | cancel | should_not           |

  @javascript
  Scenario: displays an error when visitor clicks on next with no usages selected
    Given I am on the first page of the wizard form
    When I click on "next page"
    Then I should see an error message

  @javascript
  Scenario: the error message disappear when the visitor clicks on any question
    Given I am on the first page of the wizard form
    When I click on "next page"
    And I click on the "Bureautique" super usage
    Then I should not see an error message

  @current
  @javascript
  Scenario: go to next page with one usage selected
    Given I am on the first page of the wizard form
    When I click on the "Bureautique" super usage
    When I choose the "Bureautique_1" usage
    And I click on "validate usages"
    And I click on "next page"
    Then I should be on the second page of the form 
