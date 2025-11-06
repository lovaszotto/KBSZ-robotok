*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    RPA.Excel.Files
Library    OperatingSystem
Library    String
Library    BuiltIn

*** Variables ***
${TABLE_ROWS_XPATH}       //table[contains(@class, "results")]//tbody/tr
${NEXT_BUTTON_XPATH}      //a[contains(@class, "endless_page_link") and normalize-space(text())=">"]
${EXCEL_PATH}        eredmeny.xlsx
*** Keywords ***
Beolvas Paginalt Tabla Adatokat
    #[Documentation]    Beolvassa a táblázat adatokat, és kiírja a konzolra.
    ${minden_sor}=    Create List
        # --- FEJLÉC BEOLVASÁSA ---
   ${header_cells}=    Get WebElements    //table[contains(@class, "results")]//thead/tr/th
    ${header_count}=    Get Length    ${header_cells}
    IF    ${header_count} == 0
        # Nincs <th> fejléc, próbáld td-vel
        ${header_cells}=    Get WebElements    (${TABLE_ROWS_XPATH})[1]/td
    END
    ${header_row}=    Create List
    FOR    ${cell}    IN    @{header_cells}
        ${header_text}=    Get Text    ${cell}
        Append To List    ${header_row}    ${header_text}
    END
    Log To Console    Fejléc: ${header_row}
    Append To List    ${minden_sor}    ${header_row}
     
     
     # --- ADATOK BEOLVASÁSA ---
    FOR    ${i}    IN RANGE    100
        Wait Until Page Contains Element    ${TABLE_ROWS_XPATH}    timeout=5s
        ${sorok}=    Get WebElements    ${TABLE_ROWS_XPATH}
   
        Wait Until Element Is Visible    xpath=//*[@id="main"]/section[2]/div/table    10s
        ${rows}=    Get WebElements    xpath=//*[@id="main"]/section[2]/div/table/tbody/tr
        ${row_count}=    Get Length    ${rows}
        Log    Sorok száma: ${row_count}
        # Sorok bejárása és cellák kiolvasása
      FOR    ${index}    IN RANGE    1    ${row_count + 1}
            ${cells}=    Get WebElements    xpath=(${TABLE_ROWS_XPATH})[${index}]/td
            ${cell_count}=    Get Length    ${cells}
            ${row_data}=    Create List
            FOR    ${cell_index}    IN RANGE    1    ${cell_count + 1}
                ${cell_xpath}=    Set Variable    (${TABLE_ROWS_XPATH})[${index}]/td[${cell_index}]
                ${text}=    Get Text    xpath=${cell_xpath}
                # Csak az első oszlopban keresünk linket
                IF    ${cell_index} == 1
                    ${links}=    Get WebElements    ${cell_xpath}//a
                    ${combined_text}=    Set Variable    ${text}
                    FOR    ${link}    IN    @{links}
                        ${href}=    Get Element Attribute    ${link}    href
                        ${combined_text}=    Set Variable    ${combined_text}||${href}
                    END
                    Append To List    ${row_data}    ${combined_text}
                ELSE
                    Append To List    ${row_data}    ${text}
                END
            END
            Append To List    ${minden_sor}    ${row_data}
        END
        # next button kezelése
        ${van_következő}=    Run Keyword And Return Status    Element Should Be Visible    ${NEXT_BUTTON_XPATH}
        Run Keyword Unless    ${van_következő}    Exit For Loop
        Scroll Element Into View    ${NEXT_BUTTON_XPATH}
        Click Element    ${NEXT_BUTTON_XPATH}
        Wait Until Page Contains Element    ${TABLE_ROWS_XPATH}    timeout=5s
        Sleep    0.5s
    END

    # Eredmény rendezése az első oszlop szerint
    # Feltételezzük, hogy ${minden_sor} tartalmazza a fejlécet is az első sorban!
    ${header_row}=    Remove From List    ${minden_sor}    0
    
    # Rendezés az első oszlop szerint (fejléc nélkül)
    ${rendezett_sorok}=    Copy List    ${minden_sor}
    Sort List    ${rendezett_sorok}
    # Visszarakjuk a fejlécet az elejére
    Insert Into List    ${rendezett_sorok}    0    ${header_row}
  
    #Eredmény visszaírása excelbe
    Create Workbook    ${EXCEL_PATH}
    Append Rows To Worksheet    ${minden_sor}    header=true
    Save Workbook
    Close Workbook


   #${sor_db}=    Get Length    ${minden_sor}
   # Log To Console    Beolvasott sorok száma: ${sor_db}
   # FOR    ${sor}    IN    @{minden_sor}
   #     Log To Console    ${sor}
   # END

    
    