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
    And the weight of "Bureautique" should be 50

  @javascript
  Scenario: come back to the first step of the form
    When I click on "back"
    Then I should be on the first page of the form
    And the "Bureautique" super usage should be validated

  @javascript
  Scenario: click on next with all the weights to 0
    When I set the weight for the super usage "Bureautique" to 0
    And I click on "next page"
    Then I should see an error message

  @javascript
  Scenario: click on next page
    When I click on "next page"
    Then I should be on the third page of the form

