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
