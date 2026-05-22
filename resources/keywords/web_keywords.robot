*** Settings ***
Documentation    Web Keywords — Keywords de alto nível reutilizáveis para automação WEB.
...              Combina Page Objects para criar fluxos completos de negócio.
Library          Browser
Resource         ../pages/login_page.robot
Resource         ../pages/inventory_page.robot
Resource         ../pages/cart_page.robot
Resource         ../pages/checkout_page.robot

*** Keywords ***
# ============================================================
# BROWSER SETUP
# ============================================================

Open Browser Session
    [Documentation]    Inicializa o navegador com as configurações padrão do projeto.
    New Browser         chromium    headless=true
    New Context         viewport={'width': 1280, 'height': 720}

Close Browser Session
    [Documentation]    Encerra o navegador e limpa o contexto da sessão.
    Close Browser

Take Screenshot On Failure
    [Documentation]    Captura screenshot e salva na pasta reports ao ocorrer falha.
    ${timestamp}=    Evaluate    __import__('datetime').datetime.now().strftime('%Y%m%d_%H%M%S')
    Take Screenshot    filename=${OUTPUT DIR}/screenshots/failure_${timestamp}.png

# ============================================================
# LOGIN / LOGOUT FLOWS
# ============================================================

Do Login With Valid Credentials
    [Documentation]    Realiza o login com usuário e senha válidos.
    [Arguments]        ${username}    ${password}
    Navigate To Login Page
    Fill Username Field    ${username}
    Fill Password Field    ${password}
    Submit Login Form
    Inventory Page Should Be Loaded

Do Login With Invalid Credentials
    [Documentation]    Tenta realizar login com credenciais inválidas.
    [Arguments]        ${username}    ${password}
    Navigate To Login Page
    Fill Username Field    ${username}
    Fill Password Field    ${password}
    Submit Login Form

Do Logout
    [Documentation]    Realiza o logout via menu lateral.
    Open Burger Menu
    Click Logout
    Wait For Elements State    ${USERNAME_INPUT}    visible    timeout=5s

# ============================================================
# CART FLOWS
# ============================================================

Add Product To Cart And Verify Badge
    [Documentation]    Adiciona o Backpack ao carrinho e verifica o badge.
    Add Sauce Labs Backpack To Cart
    Cart Badge Should Show    1

Add Multiple Products To Cart
    [Documentation]    Adiciona dois produtos ao carrinho e verifica o badge.
    Add Sauce Labs Backpack To Cart
    Add Sauce Labs Bike Light To Cart
    Cart Badge Should Show    2

Remove Product From Inventory Page
    [Documentation]    Remove o Backpack diretamente da listagem de produtos.
    Remove Sauce Labs Backpack From Cart
    Cart Badge Should Not Be Visible

Open Cart And Verify Item
    [Documentation]    Navega ao carrinho e verifica se o item está presente.
    [Arguments]    ${product_name}
    Navigate To Cart
    Cart Page Should Be Loaded
    Cart Should Contain Item    ${product_name}

# ============================================================
# CHECKOUT FLOW
# ============================================================

Complete Full Checkout Flow
    [Documentation]    Executa o fluxo completo de checkout até a confirmação.
    [Arguments]    ${first_name}    ${last_name}    ${postal_code}
    Navigate To Cart
    Cart Page Should Be Loaded
    Click Checkout Button
    Checkout Step One Should Be Loaded
    Fill Checkout Personal Info    ${first_name}    ${last_name}    ${postal_code}
    Click Continue To Step Two
    Checkout Step Two Should Be Loaded
    Click Finish Order
    Checkout Complete Page Should Be Loaded

Checkout Confirmation Should Be Successful
    [Documentation]    Verifica que a confirmação de pedido exibe a mensagem correta.
    ${header}=    Get Checkout Complete Header Text
    Should Be Equal As Strings    ${header}    Thank you for your order!
