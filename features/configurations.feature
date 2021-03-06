Feature: configuration
  In order to customize site behavior
  As an admin
  I want to be able to see and edit all the flowplace configuration options
  
  Background:
    Given I am logged into my account
    And I have "admin" privs
    And the default site configurations

  Scenario: admin looks at all the configuration options
    When I go to the configurations page
    Then I should be taken to the configurations page
    Then I should see "Config" as the current tab
    And I should see "Global Banner"
    And I should see "New User Policy"
    And I should see "Welcome Text"
    And I should see "Analytics"

  Scenario: non-admin user tries to look at configuration options
    When I go to the logout page
    And I am logged into my "user" account
    And I go to the configurations page
    Then I should be taken to the dashboard page
  