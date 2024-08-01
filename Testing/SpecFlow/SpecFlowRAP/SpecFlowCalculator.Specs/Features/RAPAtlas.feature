@FeatureB
Feature: RAPAtlas
A short summary of the feature

Background:
	Given i check my atlas

@myAtlasChecks
Scenario: 01 Check in Atlas the concept Course
	When i check the concept course
	Then the result should be 200

Scenario: 02 Check in Atlas the concept Student
	When i check the concept student
	Then the result should be 200

Scenario: 03 Check in Atlas the concept Module
	When i check the concept module
	Then the result should be 200

Scenario: 04 Check in Atlas the concept SESSION
	When i check the concept session
	Then the result should be 200

Scenario: 05 Check in Atlas the concept ONE
	When i check the concept one
	Then the result should be 200

Scenario: 06 Check in Atlas the rule ModuleEnrollment .TOT takes[Student*Course]
	When i check the rule moduleenrollment
	Then the result should be 200
	
Scenario: 07 Check in Atlas the rule TOT
	When i check the rule tot
	Then the result should be 200

Scenario: 08 Check in Atlas the properties TOT
	When i check the properties tot
	Then the result should be 200

Scenario: 09 Check in Atlas the relation Takes
	When i check the relation takes
	Then the result should be 200
	
Scenario: 10 Check in Atlas the relation IsPartOf
	When i check the relation ispartof
	Then the result should be 200

Scenario: 11 Check in Atlas the relation IsEnrolledFor
	When i check the relation IsEnrolledFor
	Then the result should be 200

Scenario: 12 Check in Atlas the context Enrollment
	When i check the context Enrolledment
	Then the result should be 200
