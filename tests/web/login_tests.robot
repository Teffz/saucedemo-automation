*** Settings ***
Documentation     Testes de Login — SauceDemo
...               Cobre cenários positivos e negativos do fluxo de autenticação.
Resource          ../../resources/keywords/web_keywords.robot
Resource          ../../resources/pages/login_page.robot
Variables         ../../data/web_test_data.py
Suite Setup       Open Browser Session
Suite Teardown    Close Browser Session
Test Teardown     Run Keyword If Test Failed    Take Screenshot On Failure

*** Test Cases ***

# ==============================================================
# CENÁRIOS POSITIVOS
# ==============================================================

CT-WEB-001: Login com credenciais válidas deve redirecionar para inventário
    [Documentation]    Verifica que um usuário válido consegue fazer login com sucesso
    ...                e é redirecionado para a página de produtos.
    [Tags]             smoke    login    positive
    Do Login With Valid Credentials    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Inventory Page Should Be Loaded

CT-WEB-002: Login válido deve exibir a listagem de produtos
    [Documentation]    Após login bem-sucedido, verifica que a página de inventário
    ...                contém produtos disponíveis.
    [Tags]             regression    login    positive
    Do Login With Valid Credentials    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Inventory Page Should Be Loaded
    Login Error Message Should Not Be Visible

# ==============================================================
# CENÁRIOS NEGATIVOS
# ==============================================================

CT-WEB-003: Login com senha incorreta deve exibir mensagem de erro
    [Documentation]    Verifica que ao informar senha incorreta a mensagem de erro
    ...                adequada é exibida e o usuário permanece na tela de login.
    [Tags]             smoke    login    negative
    Do Login With Invalid Credentials    ${VALID_USERNAME}    ${INVALID_PASSWORD}
    Login Error Message Should Be Visible
    ${error}=    Get Login Error Message
    Should Be Equal As Strings    ${error}    ${ERROR_INVALID_CREDENTIALS}

CT-WEB-004: Login com usuário inexistente deve exibir mensagem de erro
    [Documentation]    Verifica que usuário não cadastrado recebe mensagem de erro
    ...                ao tentar autenticar.
    [Tags]             regression    login    negative
    Do Login With Invalid Credentials    ${INVALID_USERNAME}    ${VALID_PASSWORD}
    Login Error Message Should Be Visible
    ${error}=    Get Login Error Message
    Should Be Equal As Strings    ${error}    ${ERROR_INVALID_CREDENTIALS}

CT-WEB-005: Login com usuário bloqueado deve exibir mensagem de bloqueio
    [Documentation]    Verifica que o usuário bloqueado recebe a mensagem específica
    ...                de conta bloqueada ao tentar logar.
    [Tags]             regression    login    negative
    Do Login With Invalid Credentials    ${LOCKED_OUT_USER}    ${VALID_PASSWORD}
    Login Error Message Should Be Visible
    ${error}=    Get Login Error Message
    Should Be Equal As Strings    ${error}    ${ERROR_LOCKED_OUT}

CT-WEB-006: Login sem preencher username deve exibir erro de campo obrigatório
    [Documentation]    Verifica que ao submeter o formulário sem username o sistema
    ...                solicita o preenchimento do campo.
    [Tags]             regression    login    negative
    Do Login With Invalid Credentials    ${EMPTY_USERNAME}    ${VALID_PASSWORD}
    Login Error Message Should Be Visible
    ${error}=    Get Login Error Message
    Should Be Equal As Strings    ${error}    ${ERROR_USERNAME_REQUIRED}

CT-WEB-007: Login sem preencher senha deve exibir erro de campo obrigatório
    [Documentation]    Verifica que ao submeter o formulário sem senha o sistema
    ...                solicita o preenchimento do campo.
    [Tags]             regression    login    negative
    Do Login With Invalid Credentials    ${VALID_USERNAME}    ${EMPTY_PASSWORD}
    Login Error Message Should Be Visible
    ${error}=    Get Login Error Message
    Should Be Equal As Strings    ${error}    ${ERROR_PASSWORD_REQUIRED}

# ==============================================================
# LOGOUT
# ==============================================================

CT-WEB-008: Logout deve redirecionar o usuário para a tela de login
    [Documentation]    Verifica que após logout o usuário é redirecionado
    ...                à tela de login e não consegue acessar o inventário.
    [Tags]             smoke    login    logout    positive
    Do Login With Valid Credentials    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Inventory Page Should Be Loaded
    Do Logout
    Login Error Message Should Not Be Visible
    Wait For Elements State    ${USERNAME_INPUT}    visible    timeout=5s
