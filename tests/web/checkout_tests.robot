*** Settings ***
Documentation     Testes de Checkout — SauceDemo
...               Cobre o fluxo completo de finalização de compra (positivo e negativo).
Resource          ../../resources/keywords/web_keywords.robot
Resource          ../../resources/pages/inventory_page.robot
Resource          ../../resources/pages/cart_page.robot
Resource          ../../resources/pages/checkout_page.robot
Variables         ../../data/web_test_data.py
Test Setup        Run Keywords
...               Open Browser Session
...               AND    Do Login With Valid Credentials    ${VALID_USERNAME}    ${VALID_PASSWORD}
...               AND    Add Sauce Labs Backpack To Cart
Test Teardown     Run Keywords
...               Run Keyword If Test Failed    Take Screenshot On Failure
...               AND    Close Browser Session

*** Test Cases ***

CT-WEB-017: Checkout completo deve exibir confirmação de pedido realizado
    [Documentation]    Executa o fluxo completo de compra do login até a confirmação,
    ...                validando que a mensagem de sucesso é exibida ao final.
    [Tags]             smoke    checkout    positive
    Complete Full Checkout Flow
    ...    ${CHECKOUT_FIRST_NAME}
    ...    ${CHECKOUT_LAST_NAME}
    ...    ${CHECKOUT_POSTAL_CODE}
    Checkout Confirmation Should Be Successful

CT-WEB-018: Step 2 do checkout deve exibir o resumo do pedido
    [Documentation]    Verifica que o resumo do pedido (step 2) contém o botão
    ...                de finalizar e o subtotal.
    [Tags]             regression    checkout    positive
    Navigate To Cart
    Click Checkout Button
    Checkout Step One Should Be Loaded
    Fill Checkout Personal Info
    ...    ${CHECKOUT_FIRST_NAME}
    ...    ${CHECKOUT_LAST_NAME}
    ...    ${CHECKOUT_POSTAL_CODE}
    Click Continue To Step Two
    Checkout Step Two Should Be Loaded
    ${total}=    Get Order Summary Total
    Should Contain    ${total}    Total:

CT-WEB-019: Checkout sem preencher First Name deve exibir erro
    [Documentation]    Verifica que ao tentar avançar no checkout sem o primeiro nome
    ...                o sistema exibe a mensagem de validação correspondente.
    [Tags]             regression    checkout    negative
    Navigate To Cart
    Click Checkout Button
    Checkout Step One Should Be Loaded
    Fill Checkout Personal Info    ${EMPTY_USERNAME}    ${CHECKOUT_LAST_NAME}    ${CHECKOUT_POSTAL_CODE}
    Click Continue To Step Two
    Checkout Error Should Be Visible
    ${error}=    Get Checkout Error Message
    Should Contain    ${error}    First Name is required

CT-WEB-020: Checkout sem preencher Last Name deve exibir erro
    [Documentation]    Verifica que ao tentar avançar sem sobrenome o sistema
    ...                exibe mensagem de campo obrigatório.
    [Tags]             regression    checkout    negative
    Navigate To Cart
    Click Checkout Button
    Checkout Step One Should Be Loaded
    Fill Checkout Personal Info    ${CHECKOUT_FIRST_NAME}    ${EMPTY_USERNAME}    ${CHECKOUT_POSTAL_CODE}
    Click Continue To Step Two
    Checkout Error Should Be Visible
    ${error}=    Get Checkout Error Message
    Should Contain    ${error}    Last Name is required

CT-WEB-021: Checkout sem preencher CEP deve exibir erro
    [Documentation]    Verifica que ao omitir o código postal o sistema
    ...                exibe a mensagem de campo obrigatório.
    [Tags]             regression    checkout    negative
    Navigate To Cart
    Click Checkout Button
    Checkout Step One Should Be Loaded
    Fill Checkout Personal Info    ${CHECKOUT_FIRST_NAME}    ${CHECKOUT_LAST_NAME}    ${EMPTY_USERNAME}
    Click Continue To Step Two
    Checkout Error Should Be Visible
    ${error}=    Get Checkout Error Message
    Should Contain    ${error}    Postal Code is required

CT-WEB-022: Cancelar checkout deve retornar ao carrinho
    [Documentation]    Verifica que ao clicar em "Cancel" na etapa 1 do checkout
    ...                o usuário retorna à página do carrinho.
    [Tags]             regression    checkout    negative
    Navigate To Cart
    Click Checkout Button
    Checkout Step One Should Be Loaded
    Click Cancel Checkout
    Cart Page Should Be Loaded
