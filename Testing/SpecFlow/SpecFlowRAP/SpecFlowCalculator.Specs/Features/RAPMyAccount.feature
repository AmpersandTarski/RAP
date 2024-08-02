Feature: MyAccount

Change password in my account

@tag1
Scenario: Change the password for a user
	Given i go to MyAccount
	#When i change my password
	Then the RAP result has to be 200
