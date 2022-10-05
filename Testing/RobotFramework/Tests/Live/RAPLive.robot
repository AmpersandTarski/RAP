*** Settings ***
Documentation       Testing RAP

Resource            ../../Resources/Common/Common.robot
Resource            ../../Resources/RAP/RAPApp.robot

Test Setup          Common.Begin web test    ${LOGIN_URL}    ${BROWSER}
Test Teardown       Common.End web test

*** Variables ***
${BROWSER}      chrome
${LOGIN_URL}    https://rap.cs.ou.nl/#/Login
${HOME_URL}     https://rap.cs.ou.nl/#/page/home

*** Test Cases ***
Should be able to access the Home page
    [Documentation]    Verifies if the Home page can be loaded.
    [Tags]  Smoke
    Should be able to access the Home page    ${HOME_URL}
