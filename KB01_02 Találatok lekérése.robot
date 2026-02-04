*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    excel_library.SimpleExcel
Library    OperatingSystem

*** Variables ***
${NEXT_BUTTON_XPATH}      //a[contains(@class, "endless_page_link") and normalize-space(text())=">"]
${TABLE_ROWS_XPATH}    //table[contains(@class, "results")]/tbody/tr
${EXCEL_PATH}       eredmeny.xlsx
${mylink}     ${EMPTY}
*** Keywords ***
Beolvas Paginalt Tabla Adatokat
    ${minden_sor}=    Create List

    # --- Fejléc beolvasása ---
    ${header_cells}=    Get WebElements    //table[contains(@class, "results")]//thead/tr/th
    ${header_row}=    Create List
    FOR    ${cell}    IN    @{header_cells}
        ${header_text}=    Get Text    ${cell}
        Append To List    ${header_row}    ${header_text}
    END
    Append To List    ${header_row}    Link
    Append To List    ${minden_sor}    ${header_row}

    # --- Oldalankénti beolvasás ciklus ---
    WHILE    True
        # --- Adatsorok beolvasása ---
        ${rows}=    Get WebElements    //table[contains(@class, "results")]/tbody/tr
        ${row_count}=    Get Length    ${rows}
        FOR    ${row_index}    IN RANGE    1    ${row_count + 1}
            ${cells}=    Get WebElements    xpath=(//table[contains(@class, "results")]/tbody/tr)[${row_index}]/td
            ${row_data}=    Create List
            # Első cella szövege
            ${cell_xpath}=    Set Variable    (//table[contains(@class, "results")]/tbody/tr)[${row_index}]/td[1]
            ${text}=    Get Text    xpath=${cell_xpath}
            Append To List    ${row_data}    ${text}
            # Többi cella szövege
            ${cell_count}=    Get Length    ${cells}
            FOR    ${cell_index}    IN RANGE    2     ${cell_count + 1}
                ${cell_xpath}=    Set Variable    (//table[contains(@class, "results")]/tbody/tr)[${row_index}]/td[${cell_index}]
                ${text}=    Get Text    xpath=${cell_xpath}
                Append To List    ${row_data}    ${text}
            END
            # Link(ek) első cellából
            ${links}=    Get WebElements    ${cell_xpath}//a
            ${all_links}=    Create List
            FOR    ${link}    IN    @{links}
                ${href}=    Get Element Attribute    ${link}    href
                Append To List    ${all_links}    ${href}
            END
            ${joined_links}=    Evaluate    '||'.join(${all_links})
            Append To List    ${row_data}    ${joined_links}
            Append To List    ${minden_sor}    ${row_data}
        END
        # --- Lapozás ---
        ${has_next}=    Run Keyword And Return Status    Element Should Be Visible    ${NEXT_BUTTON_XPATH}
        IF    ${has_next}
            # Ellenőrizzük, hogy van-e cookie consent panel és zárjuk be
            ${cookie_panel_visible}=    Run Keyword And Return Status    Element Should Be Visible    xpath=//div[@class='consent-actions']
            IF    ${cookie_panel_visible}
                ${close_button}=    Run Keyword And Return Status    Element Should Be Visible    xpath=//button[contains(@class, 'consent-close') or contains(text(), 'Bezár') or contains(text(), 'Close')]
                IF    ${close_button}
                    Click Element    xpath=//button[contains(@class, 'consent-close') or contains(text(), 'Bezár') or contains(text(), 'Close')]
                    Sleep    1s
                END
            END
            
            # Scroll és kattintás JavaScript-tel a biztonság kedvéért
            Scroll Element Into View    ${NEXT_BUTTON_XPATH}
            Sleep    0.5s
            
            # Próbáljunk először normál kattintással
            ${click_success}=    Run Keyword And Return Status    Click Element    ${NEXT_BUTTON_XPATH}
            
            # Ha nem sikerült, próbáljunk JavaScript-tel
            IF    not ${click_success}
                Execute JavaScript    var nextButton = document.evaluate("//a[contains(@class, 'endless_page_link') and normalize-space(text())='>']", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue; if(nextButton) nextButton.click();
            END
            
            Wait Until Page Contains Element    ${TABLE_ROWS_XPATH}    timeout=10s
            Sleep    1s
        ELSE
            BREAK
        END
    END

    # --- RENDEZÉS ---
    ${header_row}=    Get From List    ${minden_sor}    0
    ${adat_sorok}=    Get Slice From List    ${minden_sor}    1
    Sort List    ${adat_sorok}
    Insert Into List    ${adat_sorok}    0    ${header_row}

    # --- EXCELBE ÍRÁS ---
    Create Workbook    ${EXCEL_PATH}
    Append Rows To Worksheet    ${adat_sorok}    header=${False}
    Save Workbook
    # Hyperlinkek beírása
    Run    start "" "${EXCEL_PATH}"
    ${sheets}=    List Worksheets
    ${sheet}=    Set Variable    ${sheets}[0]
    ${excelRows}=    Read Worksheet    ${sheet}    header=${True}
    ${row_count}=    Get Length    ${excelRows}
    
    FOR    ${index}    IN RANGE    2    ${row_count + 1}
        ${actRow}=    Get From List    ${excelRows}    ${index - 2}
        ${mylink}=    Get From Dictionary    ${actRow}    Link
        IF    '${mylink}' != ''
            Set Cell Value With Hyperlink    ${sheet}    A${index}    ${mylink}    Link
        END
    END
    Save Workbook
    Close Workbook
    #zárja be az excelt
    Sleep    10
    Run    taskkill /IM excel.exe /F
    #Run    start "" "${EXCEL_PATH}"


*** Keywords ***

Set Cell Value With Hyperlink
    [Arguments]    ${sheet}    ${cell}    ${url}    ${text}
    Log    sheet: ${sheet}, cell: ${cell}, url: ${url}, text: ${text}
   Set Cell Value    ${sheet}     ${cell}     =HYPERLINK("${url.replace('"', '')}","${text.replace('"', '')}")
    