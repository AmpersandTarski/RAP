Feature: FeatureMyAccount

Change password in my account

@tag1
Scenario: Wijzig het wachtwoord voor een user
	Given i go to MyAccount
	#When i change my password
	Then the result is 200
