Feature: social capital currency
  In order to build reputation
  As a player
  I want to be able to use acknowledgemnts

  Background:
    Given I am logged into my account
    Given a "SocialCapital" currency "Hearts"
    Given I am a "member" of currency "Hearts"
    Given "Joe" is a "member" of currency "Hearts"

  Scenario: Users makes a play in a social capital currency
    When I go to the my currencies page
    And I follow "Hearts"
    Then I should be taken to the currency account play page for "Anonymous User's Hearts member account"
    And I should see "My Currencies Hearts: rate"
    And I should see "Average Rating: 0; Ratings Given: 0; Ratings Received: 0"
    When I select "Joe User's Hearts member account" from "play_to"
    When I select "4" from "play_rating"
    And I press "Record Play"
#    Then I should be taken to the my currencies page
    And I should see /Rating:.*0/
    And I should see /Given:.*1/
    And I should see /Received:.*0/
    When I follow "Hearts"
    And I select "Joe User's Hearts member account" from "play_to"
    And I select "2" from "play_rating"
    And I press "Record Play"
    Then I should be taken to the my currencies page
    And I should see /Rating:.*0/
    And I should see /Given:.*2/
    And I should see /Received:.*0/
    Given I go to the logout page
    Given I log in as "Joe"
    When I go to the my currencies page
    And I should see /Rating:.*3/
    And I should see /Given:.*0/
    And I should see /Received:.*2/

