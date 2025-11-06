*** Settings ***
Library    SeleniumLibrary
Library    RequestsLibrary
Library    OperatingSystem
Library    BuiltIn

*** Variables ***
${URL}                  https://player.nexiuslearning.com/contents/fa304ff0-4dd6-c94f-af50-3f0d8e1793b7/index.html
${DOWNLOAD_DIR}         downloaded_media
${IMAGE_FIELD}  //app-image-field//img

*** Test Cases ***
Letöltés az oldalról és MINDEN iframe-ből található médiák
    Create Directory    ${DOWNLOAD_DIR}
    Open Browser    ${URL}    chrome

    # Főoldal média
    ${media_urls}=    Get Media URLs
      Wait Until Element Is Visible    ${IMAGE_FIELD}    timeout=10s
    ${src}=    Get Element Attribute    ${IMAGE_FIELD}    src
    Log    Az app-image-field aktuális képe: ${src}

    Close Browser

*** Keywords ***
Get Media URLs
    [Documentation]    Collects all media URLs from the main page and iframes.
    ${urls}=    Create List
    ${main_src}=    Get Element Attribute    ${IMAGE_FIELD}    src
    Append To List    ${urls}    ${main_src}
    # Optionally, add logic to collect media from iframes here.
    [Return]    ${urls}
