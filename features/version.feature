Feature: Version

@1
Scenario: Short switch

Given Cellophane is called with "-v"
Then the current version should be displayed

@2
Scenario: Long switch

Given Cellophane is called with "--version"
Then the current version should be displayed
