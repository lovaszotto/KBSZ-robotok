
*** Settings ***
Library    SeleniumLibrary
Library    Dialogs

*** Keywords ***
CPV értékek megadása
    [Arguments]    ${cpv_value}
    Input Text   name=modal_cpv_search    ${cpv_value}
    Press Keys   name=modal_cpv_search   RETURN
    Sleep    1s
    ${tabs}=    Evaluate    "\\t" * 4
    Press Keys    None        ${tabs}
    Sleep    1s
    
    # Click hozzáadás
    Click Element    css=#cpv__list_current > ul > li > div > div > a.cpv__add
    #CtrlA meg space
   Press Keys   name=modal_cpv_search   CTRL+A
    Sleep    2s