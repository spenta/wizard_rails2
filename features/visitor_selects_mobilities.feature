Feature: visitor selects mobilities

  As a visitor
  I want to specify the relative importance of each mobilities
  So that I can see the most suitable laptops for my needs

  Background:
    Given a set of super usages with usages
    And I am on the first page of the wizard form
    And I click on the "Bureautique" super usage
    And I choose the "Bureautique_1" usage
    And I choose the "Bureautique_2" usage
    And I click on "validate usages"
    And I click on "next page"
    And I click on "next page"

  @current
  @javascript
  Scenario: see all the mobilities
    When I do nothing
    Then I should see all the mobilities
    And the weight of the "Mobilite_1" mobility should be 0
    And the weight of the "Mobilite_2" mobility should be 0
