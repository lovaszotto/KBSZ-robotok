*** Settings ***
Library    RPA.Excel.Files

*** Keywords ***

Ment Excelbe Kulcsszo
    
    [Documentation]    Ez a task beolvassa a tartalmat és beírja az Excelbe.
    [Arguments]    ${tartalom}    ${EXCEL_PATH}
    
    Open Workbook    ${EXCEL_PATH}
    Create Worksheet    name=Talalatok    exist_ok=True
    FOR    ${sor}    IN    @{tartalom}
        Append Rows To Worksheet    ${sor}    header=False
    END
    Save Workbook
    Close Workbook


*** Test Cases ***

Teszt Excel Mentese
    
    ${path}=      Set Variable    fájl.xlsx
     ${adat1}=    Create List    John    28
    ${adat2}=    Create List    Mary    34
    ${adat3}=    Create List    Alex    22
    ${adat4}=    Create List    Emma    30
    ${adat5}=    Create List    Tom     25
    ${adatok}=   Create List    ${adat1}    ${adat2}    ${adat3}    ${adat4}    ${adat5}
    Ment Excelbe Kulcsszo    ${adatok}    ${path}
