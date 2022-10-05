*** Settings ***
Resource    ./PO/RAP.HomePage.robot

*** Keywords ***
# HOME PAGE
Should be able to access the Home page
    [Arguments]    ${HOME_URL}
    RAP.HomePage.Go to the Home page        ${HOME_URL}
    RAP.HomePage.Verify that the Home page is loaded
