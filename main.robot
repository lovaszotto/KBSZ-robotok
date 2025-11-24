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
    
    # Próbáljunk több cookie button variációt
    ${cookie_accepted}=    Set Variable    ${False}
    
    # Első próba: "Minden süti elfogadása"
    ${is_visible}=    Run Keyword And Return Status
    ...    Wait Until Page Contains Element    xpath=//button[.='Minden süti elfogadása']    timeout=5s
    IF    ${is_visible}
        Click Button    xpath=//button[.='Minden süti elfogadása']
        ${cookie_accepted}=    Set Variable    ${True}
    END
    
    # Második próba: más cookie gomb variációk
    IF    not ${cookie_accepted}
        ${other_cookie_buttons}=    Create List
        ...    xpath=//button[contains(text(), 'Elfogad')]
        ...    xpath=//button[contains(text(), 'Accept')]
        ...    xpath=//button[contains(@class, 'cookie')]
        ...    xpath=//button[contains(@class, 'consent')]
        
        FOR    ${selector}    IN    @{other_cookie_buttons}
            ${button_visible}=    Run Keyword And Return Status
            ...    Wait Until Page Contains Element    ${selector}    timeout=3s
            IF    ${button_visible}
                Click Element    ${selector}
                ${cookie_accepted}=    Set Variable    ${True}
                BREAK
            END
        END
    END
    
    Sleep    2s

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

Beolvassa a Paginalt Tabla Adatokat
    # Beolvassa a táblázat adatokat, és kiírja a konzolra.
    Beolvas Paginalt Tabla Adatokat


Kilépés
  #  ${nev}=    Get Value From User    Kérlek, add meg a neved:
    Close Browser
