*** Settings ***
Library    SeleniumLibrary
Library    Dialogs

*** Variables ***
${URL}    https://www.google.com

*** Tasks ***
Kezeld A Google Sütiket
    Open Browser    ${URL}    chrome
    Maximize Browser Window
    Wait Until Page Contains Element    xpath=//button[.='Az összes elfogadása']    timeout=15s
    ${is_visible}=    Run Keyword And Return Status    Element Should Be Visible    xpath=//button[.='Az összes elfogadása']
    Run Keyword If    ${is_visible}    Click Button    xpath=//button[.='Az összes elfogadása']
    Sleep    1s
    ${nev}=  Get Value From User    Kérlek, add meg a neved:
    Input Text    name=q    Robot Framework
    Press Key    name=q    \\13
    Sleep    3s
    Close Browser
