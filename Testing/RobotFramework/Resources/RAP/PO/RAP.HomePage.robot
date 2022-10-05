*** Settings ***
Library    SeleniumLibrary

*** Variables ***


*** Keywords ***
GoToLandingPage
    [Arguments]      ${HOME_URL}
    Go To            ${HOME_URL}

VerifyLandingPageLoaded
    Wait Until Page Contains Element     xpath=//a[contains(text(),'See Ampersand documentation »')]
    Log    Trying to show homepage, page must contain button "See Ampersand Documentation"
