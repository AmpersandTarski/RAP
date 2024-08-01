#@FeatureB
Feature: RAPAtlas
A short summary of the feature

Background:
	Given i check my atlas

@myAtlasChecks
Scenario: 01 Check in Atlas the concept Course
	When i check the 'Concept' 'course'
	Then the result should be 200

Scenario: 02 Check in Atlas the concept Student
	When i check the 'Concept' 'student'
	Then the result should be 200

Scenario: 03 Check in Atlas the concept Module
	When i check the 'Concept' 'module'
	Then the result should be 200

Scenario: 04 Check in Atlas the concept SESSION
	When i check the 'Concept' 'session'
	Then the result should be 200

Scenario: 05 Check in Atlas the concept ONE
	When i check the 'Concept' 'one'
	Then the result should be 200

Scenario: 06 Check in Atlas the Rule ModuleEnrollment .TOT takes[Student*Course]
	When i check the 'Rule' 'moduleenrollment'
	Then the result should be 200
	
Scenario: 07 Check in Atlas the rule TOT
	When i check the 'Rule' 'tot'
	Then the result should be 200

Scenario: 08 Check in Atlas the properties TOT
	When i check the properties tot
	Then the result should be 200

Scenario: 09 Check in Atlas the relation Takes
	When i check the 'Relation' 'takes'
	Then the result should be 200
	
Scenario: 10 Check in Atlas the relation IsPartOf
	When i check the 'Relation' 'ispartof'
	Then the result should be 200

Scenario: 11 Check in Atlas the relation IsEnrolledFor
	When i check the 'Relation' 'IsEnrolledFor'
	Then the result should be 200

Scenario: 12 Check in Atlas the context Enrollment
	When i check the 'Context' 'Enrollment'
	Then the result should be 200
