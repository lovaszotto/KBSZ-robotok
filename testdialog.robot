*** Settings ***
Library    Dialogs

*** Test Cases ***
Adatbekérés
    ${nev}=  Get Value From User    Kérlek, add meg a neved:
    Log    A megadott név: ${nev}
