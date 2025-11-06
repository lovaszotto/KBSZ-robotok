*** Settings ***
Library                 RPA.Outlook.Application
Task Setup              Open Application
Suite Teardown          Quit Application

*** Variables ***
${RECIPIENT}            lovasz.otto@clarity.hu
*** Tasks ***
Send email
    Send Email         recipients=${RECIPIENT}
    ...                subject=This is the subject
    ...                body=This is the message body 
    ...                attachments=pelda.xlsx