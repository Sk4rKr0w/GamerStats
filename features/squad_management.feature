Feature: Squad management
  As a user
  I want to create and manage squads
  So that I can save my favorite squads

  Scenario: Creating a new squad
    Given I am logged in as a user
    When I navigate to the my squad page
    And I fill in the squad details
    And I submit the squad form
    Then I should see the squad details page

  Scenario: Saving a squad
    Given I am logged in as a user
    And I have created a squad
    When I save the squad
    Then the squad should be marked as saved

  Scenario: Viewing saved squads
    Given I am logged in as a user
    And I have saved a squad
    When I navigate to my squads page
    Then I should see the saved squad