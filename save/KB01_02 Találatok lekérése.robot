*** Settings ***
Library    SeleniumLibrary
Library    Collections

Resource    KB01_03 Excelbe írás.robot

*** Variables ***
${TABLE_ROWS_XPATH}       //table[contains(@class, "results")]//tbody/tr
${NEXT_BUTTON_XPATH}      //a[contains(@class, "endless_page_link") and normalize-space(text())=">"]
${EXCEL_PATH}             eredmenyek.xlsx

*** Keywords ***
Beolvas Paginalt Tabla Adatokat
    #[Documentation]    Beolvassa a táblázat adatokat, és kiírja a konzolra.
    ${adatok}=    Create List

    FOR    ${i}    IN RANGE    100
        Wait Until Page Contains Element    ${TABLE_ROWS_XPATH}    timeout=5s
        ${sorok}=    Get WebElements    ${TABLE_ROWS_XPATH}
        Wait Until Element Is Visible    xpath=//*[@id="main"]/section[2]/div/table    10s
        ${rows}=    Get WebElements    xpath=//*[@id="main"]/section[2]/div/table/tbody/tr
        ${row_count}=    Get Length    ${rows}
        Log    Sorok száma: ${row_count}
        # Sorok bejárása és cellák kiolvasása
        FOR    ${index}    IN RANGE    1    ${row_count + 1}
            ${cells}=    Get WebElements    xpath=(//*[@id="main"]/section[2]/div/table/tbody/tr)[${index}]/td
            ${row_data}=    Create List
            FOR    ${cell}    IN    @{cells}
                ${text}=    Get Text    ${cell}
                Append To List    ${row_data}    ${text}
            END
            Log    Sor adatai: ${row_data}
        END
        # next button kezelése
        ${van_következő}=    Run Keyword And Return Status    Element Should Be Visible    ${NEXT_BUTTON_XPATH}
        Run Keyword Unless    ${van_következő}    Exit For Loop
        Scroll Element Into View    ${NEXT_BUTTON_XPATH}
        Click Element    ${NEXT_BUTTON_XPATH}
        Wait Until Page Contains Element    ${TABLE_ROWS_XPATH}    timeout=5s
        Sleep    0.5s
    END
    #Ment Excelbe    ${adatok}
   ${sor_db}=    Get Length    ${adatok}
    Log To Console    Beolvasott sorok száma: ${sor_db}
    FOR    ${sor}    IN    @{adatok}
        Log To Console    ${sor}
    END

    