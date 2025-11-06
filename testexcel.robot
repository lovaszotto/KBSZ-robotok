*** Settings ***
Library    RPA.Excel.Files
Library    OperatingSystem

*** Test Cases ***
Excel Test
    Create Workbook    output.xlsx
    Save Workbook

Excel Megnyitása
    Open Workbook    output.xlsx
    # Itt adhatsz hozzá további műveleteket, pl. olvasás, írás, stb.
    Close Workbook
Excel Megnyitása Programmal
    Run    start excel.exe output.xlsx

Excel Megnyitása Programmal és bezárása
    Run    start excel.exe output.xlsx
    Sleep    5s    # Várakozás, hogy lásd a megnyitott Excelt
    Run    taskkill /IM excel.exe /F
    Sleep    5s
Excel Új Sheet-tel Megnyitva
    Open Workbook    output.xlsx
    Create Worksheet    uj_sheet
    Save Workbook
    Close Workbook
    Run    start excel.exe output.xlsx

Excel A2 cellába ír
    Open Workbook    output.xlsx
   # Remove Worksheet    uj_sheet
    # Create Worksheet    uj_sheet
     Set Active Worksheet    uj_sheet
    Sleep    1s
    Set Cell Value    1    2    123
    Set Cell Value    1    1    alma

    Save Workbook
    Close Workbook
    Run    start excel.exe output.xlsx