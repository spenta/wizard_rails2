Feature: visitor fills in wizard form

  As a visitor
  I want to fill in the wizard form
  So that I can see the most suitable laptops for my needs
  
  Background:
    Given a set of super usages
    And a set of usages

  Scenario: see all super usages
    Given I am on the first page of the wizard form
    When I do nothing
    Then I should see all the super usages
    And no super usages should be selected

  Scenario Outline: select super usages
    Given I am on the first page of the wizard form
    When I click on the "<super_usage>" super usage
    Then I should see a number of "<usages_number>" usages
    And I should see the usage "<usage_example>"
    But I should not see the usage "<bad_usage_example>"

    Scenarios: select documents
      | super_usage  | usages_number | usage_example | bad_usage_example |
      | super_usage1 | 2             | usage1a       | usage2a           |
      | super_usage1 | 2             | usage2a       | usage2b           |
      | super_usage2 | 3             | usage2a       | usage1a           |
      | super_usage2 | 3             | usage2b       | usage1b           |
      | super_usage2 | 3             | usage2c       | usage1a           |
