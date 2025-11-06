*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    RPA.Excel.Files
Library    OperatingSystem

*** Variables ***

${TABLE_ROWS_XPATH}    //table[contains(@class, "results")]/tbody/tr
${EXCEL_PATH}       eredmeny.xlsx

*** Keywords ***
Beolvas Paginalt Tabla Adatokat
    [Documentation]    Beolvassa a HTML táblázatot, a fejlécet is, az első oszlopban keres linket és csak a hivatkozást az utolsó oszlopba írja, majd az első oszlop szerint rendezi (fejlécet nem rendezi). Az eredményt Excelbe menti.
    ${minden_sor}=    Create List

    # --- FEJLÉC (első sor) beolvasása ---
# --- FEJLÉC beolvasása ---
    ${header_cells}=    Get WebElements    //table[contains(@class, "results")]//thead/tr/th
    ${header_count}=    Get Length    ${header_cells}
    IF    ${header_count} > 0
        ${header_row}=    Create List
        FOR    ${cell}    IN    @{header_cells}
            ${header_text}=    Get Text    ${cell}
            Append To List    ${header_row}    ${header_text}
        END
    ELSE
        ${header_cells}=    Get WebElements    (${TABLE_ROWS_XPATH})[1]/td
        ${header_row}=    Create List
        FOR    ${cell}    IN    @{header_cells}
            ${header_text}=    Get Text    ${cell}
            Append To List    ${header_row}    ${header_text}
        END
    END
    Append To List    ${header_row}    Link
    Append To List    ${minden_sor}    ${header_row}

    # --- ADATOK beolvasása ---
    ${rows}=    Get WebElements    ${TABLE_ROWS_XPATH}
    ${row_count}=    Get Length    ${rows}
    FOR    ${index}    IN RANGE    2    ${row_count + 1}    # 2-től, mert 1. sor a fejléc
        ${cells}=    Get WebElements    xpath=(${TABLE_ROWS_XPATH})[${index}]/td
        ${cell_count}=    Get Length    ${cells}
        ${row_data}=    Create List
        # Az első cella szövege
        ${cell_xpath}=    Set Variable    (${TABLE_ROWS_XPATH})[${index}]/td[1]
        ${text}=    Get Text    xpath=${cell_xpath}
        Append To List    ${row_data}    ${text}
        # A többi cella szövege
        FOR    ${cell_index}    IN RANGE    2    ${cell_count + 1}
            ${cell_xpath}=    Set Variable    (${TABLE_ROWS_XPATH})[${index}]/td[${cell_index}]
            ${text}=    Get Text    xpath=${cell_xpath}
            Append To List    ${row_data}    ${text}
        END
        # Link(ek) az első cellából
        ${links}=    Get WebElements    (${TABLE_ROWS_XPATH})[${index}]/td[1]//a
        ${all_links}=    Create List
        FOR    ${link}    IN    @{links}
            ${href}=    Get Element Attribute    ${link}    href
            Append To List    ${all_links}    ${href}
        END
        ${joined_links}=    Evaluate    '||'.join(${all_links})
        Append To List    ${row_data}    ${joined_links}
        Append To List    ${minden_sor}    ${row_data}
    END

    # --- RENDEZÉS ---
    ${header_row}=    Get From List    ${minden_sor}    0
    ${adat_sorok}=    Get Slice From List    ${minden_sor}    1
    Sort List    ${adat_sorok}
    Insert Into List    ${adat_sorok}    0    ${header_row}

    # --- EXCELBE ÍRÁS ---
    Create Workbook    ${EXCEL_PATH}
    Append Rows To Worksheet    ${adat_sorok}    header=false
    Save Workbook
    Close Workbook
    #Start Process    ${EXCEL_PATH}
    Run    start excel.exe ${EXCEL_PATH}
    #[Teardown]    Close Browser

