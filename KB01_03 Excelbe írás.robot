*** Settings ***
Library    RPA.Excel.Files

*** Variables ***
${EXCEL_PATH}    eredmeny.xlsx

*** Test Cases ***
Adatok cellankent Excelbe
    ${adat1}=    Create List    John    28
    ${adat2}=    Create List    Mary    34
    ${adat3}=    Create List    Alex    22
    ${adat4}=    Create List    Emma    30
    ${adat5}=    Create List    Tom     25
    ${adatok}=    Create List    ${adat1}    ${adat2}    ${adat3}    ${adat4}    ${adat5}

    Create Workbook    ${EXCEL_PATH}
    Append Rows To Worksheet    ${adatok}    header=false
    Save Workbook
    Close Workbook