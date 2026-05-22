*** Settings ***
Documentation    Page Object — SauceDemo Login Page
...              Contém todos os seletores e keywords de baixo nível da página de login.
Library          Browser

*** Variables ***
${LOGIN_URL}           https://www.saucedemo.com
${USERNAME_INPUT}      id=user-name
${PASSWORD_INPUT}      id=password
${LOGIN_BUTTON}        id=login-button
${ERROR_MESSAGE}       css=[data-test="error"]
${ERROR_CLOSE_BTN}     css=.error-button

*** Keywords ***
Navigate To Login Page
    [Documentation]    Navega até a página de login do SauceDemo e aguarda o carregamento.
    New Page           ${LOGIN_URL}
    Wait For Elements State    ${USERNAME_INPUT}    visible    timeout=10s

Fill Username Field
    [Documentation]    Preenche o campo de usuário com o valor informado.
    [Arguments]        ${username}
    Fill Text          ${USERNAME_INPUT}    ${username}

Fill Password Field
    [Documentation]    Preenche o campo de senha com o valor informado.
    [Arguments]        ${password}
    Fill Text          ${PASSWORD_INPUT}    ${password}

Submit Login Form
    [Documentation]    Clica no botão de login para submeter o formulário.
    Click              ${LOGIN_BUTTON}

Get Login Error Message
    [Documentation]    Retorna o texto da mensagem de erro exibida na tela.
    ${error_text}=     Get Text    ${ERROR_MESSAGE}
    RETURN             ${error_text}

Login Error Message Should Be Visible
    [Documentation]    Verifica que a mensagem de erro está visível na tela.
    Wait For Elements State    ${ERROR_MESSAGE}    visible    timeout=5s

Login Error Message Should Not Be Visible
    [Documentation]    Verifica que nenhuma mensagem de erro está exibida.
    Wait For Elements State    ${ERROR_MESSAGE}    hidden    timeout=5s

Close Login Error Message
    [Documentation]    Fecha a mensagem de erro clicando no botão X.
    Click    ${ERROR_CLOSE_BTN}
