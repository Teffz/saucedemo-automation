*** Settings ***
Documentation     Testes Data Driven — Login SauceDemo
...               Valida múltiplos cenários de login usando Test Template.
...               Cada linha da tabela representa um cenário independente,
...               eliminando duplicação de código e facilitando a manutenção.
Resource          ../../resources/keywords/web_keywords.robot
Resource          ../../resources/pages/login_page.robot
Variables         ../../data/web_test_data.py
Suite Setup       Open Browser Session
Suite Teardown    Close Browser Session
Test Teardown     Run Keyword If Test Failed    Take Screenshot On Failure

*** Test Cases ***

# ==============================================================
# DATA DRIVEN — LOGIN INVÁLIDO
# Cada linha = 1 cenário executado automaticamente
# ==============================================================

CT-DDT-001: Login inválido — ${scenario}
    [Documentation]    Valida mensagem de erro para diferentes tipos de credenciais inválidas.
    ...                O Template executa o keyword abaixo para cada linha de dados.
    [Tags]             regression    login    negative    ddt
    [Template]         Validate Login Error Message
    # SCENARIO                       USERNAME                  PASSWORD             EXPECTED ERROR
    Senha incorreta                  ${VALID_USERNAME}         wrong_password       ${ERROR_INVALID_CREDENTIALS}
    Usuário inexistente              usuario_inexistente        ${VALID_PASSWORD}    ${ERROR_INVALID_CREDENTIALS}
    Usuário e senha inválidos        usuario_errado            senha_errada         ${ERROR_INVALID_CREDENTIALS}
    Usuário bloqueado                ${LOCKED_OUT_USER}        ${VALID_PASSWORD}    ${ERROR_LOCKED_OUT}
    Username vazio                   ${EMPTY_USERNAME}         ${VALID_PASSWORD}    ${ERROR_USERNAME_REQUIRED}
    Password vazio                   ${VALID_USERNAME}         ${EMPTY_PASSWORD}    ${ERROR_PASSWORD_REQUIRED}

CT-DDT-002: Login válido por tipo de usuário — ${scenario}
    [Documentation]    Valida que diferentes tipos de usuário válidos conseguem autenticar.
    [Tags]             regression    login    positive    ddt
    [Template]         Validate Successful Login
    # SCENARIO                        USERNAME                          PASSWORD
    Usuário padrão                    ${VALID_USERNAME}                 ${VALID_PASSWORD}
    Usuário com glitch                ${PERFORMANCE_GLITCH_USER}        ${VALID_PASSWORD}

*** Keywords ***

Validate Login Error Message
    [Documentation]    Keyword do Template: executa login e valida a mensagem de erro esperada.
    [Arguments]        ${scenario}    ${username}    ${password}    ${expected_error}
    Navigate To Login Page
    Fill Username Field    ${username}
    Fill Password Field    ${password}
    Submit Login Form
    Login Error Message Should Be Visible
    ${actual_error}=    Get Login Error Message
    Should Be Equal As Strings    ${actual_error}    ${expected_error}

Validate Successful Login
    [Documentation]    Keyword do Template: executa login válido e valida redirecionamento.
    [Arguments]        ${scenario}    ${username}    ${password}
    Do Login With Valid Credentials    ${username}    ${password}
    Inventory Page Should Be Loaded
    Do Logout
