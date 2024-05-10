Feature: RAP
Simple RAP features for a start

// Link to a feature: [Calculator](SpecFlowRAP.Specs/Features/Calculator.feature)
***Further read***: **[Learn more about how to generate Living Documentation](https://docs.specflow.org/projects/specflow-livingdoc/en/latest/LivingDocGenerator/Generating-Documentation.html)**


#@myLogintag
#Scenario: I can login when i just installed the application of RAP
#	Given i just ran the installer of rap
#	When i try to login
#	Then the result is 123

@myWelcometag
Scenario: In the welcome screen I can request the Overview-page
	Given i am in the welcome screen of rap
	When i request the overview page
	Then the result is 123

Scenario: In the welcome screen I can request the List-all-interfaces-page
	Given i am in the welcome screen of rap
	When i request the listallinterfaces page
	Then the result is 7

Scenario: In the welcome screen I can request the Edit-navigation-menu-page
	Given i am in the welcome screen of rap
	When i request the editnavigationmenu page
	Then the result is 1

@myOverviewtag
Scenario: In the overview screen I can request the number of courses
	Given i am in the overview screen of rap
	When i request for courses
	Then the result is 2

Scenario: In the overview screen I can request the number of students
	Given i am in the overview screen of rap
	When i request for students
	Then the result is 3

Scenario: In the overview screen I can request the number of modules
	Given i am in the overview screen of rap
	When i request for modules
	Then the result is 4

@myInterfaces
Scenario: In the "List all interfaces" page I can request the "edit an interface" interface
	Given i am in the list all interfaces screen of rap
	When i edit the interface
	Then the result is 123

Scenario: In the "List all interfaces" page I can request the "edit a menu item" interface
	Given i am in the list all interfaces screen of rap
	When i edit a menu item
	Then the result is 123

Scenario: In the "List all interfaces" page I can request the "list all interfaces" interface
	Given i am in the list all interfaces screen of rap
	When i request the sub listallinterfaces page
	Then the result is 123

Scenario: In the "List all interfaces" page I can request the "overview" interface
    Given i am in the list all interfaces screen of rap
	When i request the sub overview page
	Then the result is 123

Scenario: In the "List all interfaces" page I can request the "PF__AllRoles interface
    Given i am in the list all interfaces screen of rap
	When i request the sub pf allroles page
	Then the result is 123


Scenario: In the "List all interfaces" page I can request the "PF__MenuItems interface
    Given i am in the list all interfaces screen of rap
	When i request the sub pf menuitems page
	Then the result is 123
