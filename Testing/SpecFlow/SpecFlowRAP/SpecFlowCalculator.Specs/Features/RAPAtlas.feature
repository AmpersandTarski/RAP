Feature: RAPAtlas

A short summary of the feature

@myinstallation
Scenario: 01 I can reinstall the application and create an account
    # "/admin/installer" -> response is 
	Given i reinstall the application
	And i need a session id of RAP
	And i need to see the register button
	And i need a register id of RAP
	When i fill in my userid
	And i fill in my password and name
	And i create my account
	#And i log out
	#And i confirm my log out
	Then the RAP result should be 200
	 
#Scenario: When I have an account I can login
#	Given i need a session id of RAP
#	When i try to login
#	Then the result should be 200

@myWelcometag
Scenario: 02 When I am logged in I can add a new script
	Given i want to add a new script
	When i add my latest script
	And compile my latest script
	Then the RAP result should be 200

@myAtlasChecks
Scenario: 03 Check in Atlas the concept Course
	Given i check my atlas
	When i check the concept course
	Then the result should be 200

Scenario: 04 Check in Atlas the concept Student
	Given i check my atlas
	When i check the concept student
	Then the result should be 200

Scenario: 05 Check in Atlas the concept Module
	Given i check my atlas
	When i check the concept module
	Then the result should be 200

Scenario: 06 Check in Atlas the concept SESSION
	Given i check my atlas
	When i check the concept session
	Then the result should be 200

Scenario: 07 Check in Atlas the concept ONE
	Given i check my atlas
	When i check the concept one
	Then the result should be 200

Scenario: 08 Check in Atlas the rule ModuleEnrollment .TOT takes[Student*Course]
	Given i check my atlas
	When i check the rule moduleenrollment
	Then the result should be 200
	
Scenario: 09 Check in Atlas the rule TOT
	Given i check my atlas
	When i check the rule tot
	Then the result should be 200
	
Scenario: 10 Check in Atlas the relation Takes
	Given i check my atlas
	When i check the relation takes
	Then the result should be 200
	
Scenario: 10 Check in Atlas the relation IsPartOf
	Given i check my atlas
	When i check the relation ispartof
	Then the result should be 200
