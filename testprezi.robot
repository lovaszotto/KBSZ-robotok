*** Settings ***
Library    PptxLibrary

*** Test Cases ***
Készíts PPT prezentációt
    New Presentation    output.pptx
    Add Slide    title_and_content
    Set Title    0    Találatok prezentáció
    Set Content  0    Ez a prezentáció a webes találatok feldolgozásáról szól.
    Add Slide    title_and_content
    Set Title    1    Fő lépések
    Set Content  1    - Táblázat beolvasása\n- Adatok feldolgozása\n- Eredmények Excelbe írása
    Save Presentation