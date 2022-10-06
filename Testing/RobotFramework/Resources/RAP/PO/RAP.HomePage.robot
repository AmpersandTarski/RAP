*** Settings ***
Library    SeleniumLibrary

*** Variables ***


*** Keywords ***
Go to the Home page
    [Arguments]      ${HOME_URL}
    Go To            ${HOME_URL}

Verify that the Home page is loaded
    Wait Until Page Contains Element     xpath=//a[contains(text(),'See Ampersand documentation »')]    15
    Log    Trying to show homepage, page must contain button "See Ampersand Documentation"
