*** Settings ***
Resource    ./PO/RAP.HomePage.robot

*** Keywords ***
# HOME PAGE
Should be able to access the Home page
    [Arguments]    ${HOME_URL}
    RAP.HomePage.GoToLandingPage        ${HOME_URL}
    RAP.HomePage.VerifyLandingPageLoaded
