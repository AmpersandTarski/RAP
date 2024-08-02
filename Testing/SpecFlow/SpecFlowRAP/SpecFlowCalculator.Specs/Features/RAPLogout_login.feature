Feature: Logout_login

A short summary of the feature

@tag1
Scenario: Log out when you are logged in
	When i log out
	And i confirm my log out
	Then i can log myself in
	And the RAP result must be 200