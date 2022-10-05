*** Settings ***
Library    SeleniumLibrary

*** Variables ***

*** Keywords ***
Begin web test
    [Arguments]    ${START_URL}    ${BROWSER}
    Open Browser    ${START_URL}   ${BROWSER}
    Maximize Browser Window
    Sleep     1s

End web test
    Close All Browsers
    