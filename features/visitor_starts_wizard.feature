Feature: visitor starts wizard

  As a visitor
  I want to start the wizard
  So that I can answer questions about my needs

  Scenario: start wizard
    Given I am on the home page
    When I follow "start_wizard"
    Then I should be on the first page of the form
