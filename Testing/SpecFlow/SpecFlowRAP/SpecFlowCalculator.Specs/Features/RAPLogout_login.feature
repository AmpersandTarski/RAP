Feature: Featurelogin

A short summary of the feature

@tag1
Scenario: Log out when you are logged in
	When i log out
	And i confirm my log out
	And i try to login
