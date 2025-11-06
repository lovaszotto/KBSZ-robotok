*** Settings ***
Library    RPA.Word.Files

*** Variables ***
${DOCX_PATH}    példa_dokumentum.docx

*** Test Cases ***
Olvassa Be A DOCX Fájlt
    Open Word Document    ${DOCX_PATH}
    ${tartalom}=    Get Text From Word Document
    Log    A fájl tartalma:\n${tartalom}
    Close Word Document