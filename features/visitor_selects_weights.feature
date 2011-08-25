Feature: visitor selects weights

  As a visitor
  I want to specify the relative importance of each usage
  So that I can see the most suitable laptops for my needs

  Background:
    Given a set of super usages with usages
    And I am on the first page of the wizard form
    And I click on the "Bureautique" super usage
    And I choose the "Bureautique_1" usage
    And I choose the "Bureautique_2" usage
    And I click on "validate usages"
    And I click on "next page"

  @javascript
  Scenario: see only the chosen usages
    When I do nothing
    Then I should see only the super usage "Bureautique"
