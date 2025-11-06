*** Settings ***
Library    SeleniumLibrary
Library    Collections

*** Variables ***
${TABLE_ROWS_XPATH}       //table[contains(@class, "results")]//tbody/tr
${NEXT_BUTTON_XPATH}      //a[contains(@class, "endless_page_link") and normalize-space(text())=">"]

*** Keywords ***
Beolvas Paginalt Tabla Adatokat
    #[Documentation]    Beolvassa a táblázat adatokat, és kiírja a konzolra.
    ${minden_sor}=    Create List

    FOR    ${i}    IN RANGE    100
        Wait Until Page Contains Element    ${TABLE_ROWS_XPATH}    timeout=5s
        ${sorok}=    Get WebElements    ${TABLE_ROWS_XPATH}
        #FOR    ${sor}    IN    @{sorok}
            
            #${cellák}=    Execute Javascript    return arguments[0].querySelectorAll('td');    ${sor}
            #${cellák}=    Execute Javascript    return arguments[0].querySelectorAll('td');    ${sor}
            #Log    ${cellák}

            #${értékek}=    Create List
            #FOR    ${cella}    IN    @{cellák}
            #    ${szöveg}=    Get Text    ${cella}
            #    Append To List    ${értékek}    ${szöveg}
            #END
            #${sor_szöveg}=    Catenate    SEPARATOR= |    @{értékek}
            #Append To List    ${minden_sor}    ${sor_szöveg}
            
        #END
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

   ${sor_db}=    Get Length    ${minden_sor}
    Log To Console    Beolvasott sorok száma: ${sor_db}
    FOR    ${sor}    IN    @{minden_sor}
        Log To Console    ${sor}
    END

    
    