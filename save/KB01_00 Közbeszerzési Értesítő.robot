*** Settings ***
Library     SeleniumLibrary
Library     Dialogs
Library     Collections

Resource    KB01_01 CPV megadás.robot
Resource    KB01_02 Találatok lekérése.robot



*** Variables ***
${URL}      https://kozbeszerzes.hu/adatbazis/keres/hirdetmeny/


*** Tasks ***
Kezeld A Sütiket
    Open Browser    ${URL}    chrome
    Maximize Browser Window
    Wait Until Page Contains Element    xpath=//button[.='Minden süti elfogadása']    timeout=15s
    ${is_visible}=    Run Keyword And Return Status
    ...    Element Should Be Visible
    ...    xpath=//button[.='Minden süti elfogadása']

    IF    ${is_visible}
        Click Button    xpath=//button[.='Minden süti elfogadása']
    END
    ${ENTER}=    Set Variable    \\13
    Sleep    1s

CPV értékek megadása
    # popup ablak fellövése
    Click Element    xpath=//*[@class='form-control form-control_cpv']
    #várd meg az ablak megjelenését
    Wait Until Page Contains Element    name=modal_cpv_search    timeout=15s

    # Értékek megadása
    CPV értékek megadása    72230000
    #CPV értékek megadása    32000000
    
    Sleep     1s
    #Hozzáad gomb megnyomása
    Click Link    xpath=//a[.//span[contains(normalize-space(), 'Hozzáad')]]
    # Várd meg, hogy a popup bezáruljon
    Wait Until Element Is Not Visible    xpath=//a[.//span[text()='Hozzáad']]    10s

Beállít Dátumtól És Dátumig
    #Tól Ig dátumok kitöltése
    #Clear Element Text    xpath=//input[@placeholder='Dátumtól']
    #Input Text    xpath=//input[@placeholder='Dátumtól']    2021-07-01

    Clear Element Text    xpath=//input[@placeholder='Dátumig']
    Input Text    xpath=//input[@placeholder='Dátumig']    2025-07-08

Szűrés gomb megnyomása
    # Szűrés gomb megnyomása
    Wait Until Element Is Visible    xpath=//button[contains(normalize-space(), 'Szűrés')]    10s
    #Nem látható gomb megnyomása
    Execute JavaScript    document.evaluate("//button[contains(normalize-space(), 'Szűrés')]", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click();

Táblázat Kiolvasása
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
        #Log    Sor adatai: ${row_data}
    END

Beolvassa a Paginalt Tabla Adatokat
    # Beolvassa a táblázat adatokat, és kiírja a konzolra.
    Beolvas Paginalt Tabla Adatokat

    
Beolvas Paginalt Tabla Adatokat
    ${nev}=    Get Value From User    Kérlek, add meg a neved:
    Close Browser
