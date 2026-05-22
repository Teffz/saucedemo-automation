*** Settings ***
Documentation    Page Object — SauceDemo Checkout Pages
...              Contém seletores e keywords das etapas de checkout (Step One e Step Two).
Library          Browser

*** Variables ***
# --- Checkout Step One ---
${CHECKOUT_STEP_ONE_URL}     https://www.saucedemo.com/checkout-step-one.html
${FIRST_NAME_INPUT}          css=[data-test="firstName"]
${LAST_NAME_INPUT}           css=[data-test="lastName"]
${POSTAL_CODE_INPUT}         css=[data-test="postalCode"]
${CONTINUE_BTN}              css=[data-test="continue"]
${CANCEL_BTN}                css=[data-test="cancel"]
${CHECKOUT_ERROR_MSG}        css=[data-test="error"]

# --- Checkout Step Two ---
${CHECKOUT_STEP_TWO_URL}     https://www.saucedemo.com/checkout-step-two.html
${SUMMARY_TOTAL}             css=.summary_total_label
${SUMMARY_SUBTOTAL}          css=.summary_subtotal_label
${FINISH_BTN}                css=[data-test="finish"]
${STEP_TWO_CANCEL_BTN}       css=[data-test="cancel"]

# --- Checkout Complete ---
${CHECKOUT_COMPLETE_URL}     https://www.saucedemo.com/checkout-complete.html
${COMPLETE_HEADER}           css=.complete-header
${COMPLETE_TEXT}             css=.complete-text
${BACK_HOME_BTN}             css=[data-test="back-to-products"]

*** Keywords ***
Checkout Step One Should Be Loaded
    [Documentation]    Verifica que a primeira etapa do checkout foi carregada.
    Wait For Elements State    ${FIRST_NAME_INPUT}    visible    timeout=10s

Fill Checkout Personal Info
    [Documentation]    Preenche os dados pessoais no formulário de checkout.
    [Arguments]    ${first_name}    ${last_name}    ${postal_code}
    Fill Text    ${FIRST_NAME_INPUT}    ${first_name}
    Fill Text    ${LAST_NAME_INPUT}     ${last_name}
    Fill Text    ${POSTAL_CODE_INPUT}   ${postal_code}

Click Continue To Step Two
    [Documentation]    Clica em "Continue" para avançar ao step 2.
    Click    ${CONTINUE_BTN}

Click Cancel Checkout
    [Documentation]    Cancela o checkout e retorna ao carrinho.
    Click    ${CANCEL_BTN}

Checkout Step Two Should Be Loaded
    [Documentation]    Verifica que o resumo do pedido foi carregado (step 2).
    Wait For Elements State    ${FINISH_BTN}    visible    timeout=10s

Get Order Summary Total
    [Documentation]    Retorna o texto do total do pedido no step 2.
    ${total}=    Get Text    ${SUMMARY_TOTAL}
    RETURN    ${total}

Click Finish Order
    [Documentation]    Finaliza o pedido clicando no botão "Finish".
    Click    ${FINISH_BTN}

Checkout Complete Page Should Be Loaded
    [Documentation]    Verifica que a página de confirmação do pedido foi carregada.
    Wait For Elements State    ${COMPLETE_HEADER}    visible    timeout=10s

Get Checkout Complete Header Text
    [Documentation]    Retorna o texto do cabeçalho da página de confirmação.
    ${header}=    Get Text    ${COMPLETE_HEADER}
    RETURN    ${header}

Checkout Error Should Be Visible
    [Documentation]    Verifica que uma mensagem de erro está visível no checkout.
    Wait For Elements State    ${CHECKOUT_ERROR_MSG}    visible    timeout=5s

Get Checkout Error Message
    [Documentation]    Retorna o texto da mensagem de erro do checkout.
    ${error}=    Get Text    ${CHECKOUT_ERROR_MSG}
    RETURN    ${error}
