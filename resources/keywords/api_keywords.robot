*** Settings ***
Documentation    API Keywords — Keywords reutilizáveis para automação de API REST.
...              Utiliza RequestsLibrary para interagir com a API ReqRes.
Library          RequestsLibrary
Library          Collections
Library          String

*** Variables ***
${BASE_URL}         https://reqres.in
${API_PREFIX}       /api
${SESSION_ALIAS}    reqres_session
${CONTENT_TYPE}     application/json
${API_KEY}          free_user_3E3U5AHnGkWLFyzRC3wBUg1pEpu

*** Keywords ***
# ============================================================
# SESSION MANAGEMENT
# ============================================================

Create API Session
    [Documentation]    Cria a sessão HTTP reutilizável para os testes de API.
    ${headers}=    Create Dictionary
    ...    Content-Type=${CONTENT_TYPE}
    ...    Accept=application/json
    ...    x-api-key=${API_KEY}
    Create Session
    ...    alias=${SESSION_ALIAS}
    ...    url=${BASE_URL}
    ...    headers=${headers}
    ...    verify=True

# ============================================================
# REQUEST HELPERS
# ============================================================

GET Request To
    [Documentation]    Executa uma requisição GET e retorna o objeto response.
    [Arguments]    ${endpoint}    ${params}=${None}
    ${response}=    GET On Session
    ...    ${SESSION_ALIAS}
    ...    ${API_PREFIX}${endpoint}
    ...    params=${params}
    ...    expected_status=any
    RETURN    ${response}

POST Request To
    [Documentation]    Executa uma requisição POST com body JSON e retorna o response.
    [Arguments]    ${endpoint}    ${body}
    ${response}=    POST On Session
    ...    ${SESSION_ALIAS}
    ...    ${API_PREFIX}${endpoint}
    ...    json=${body}
    ...    expected_status=any
    RETURN    ${response}

PUT Request To
    [Documentation]    Executa uma requisição PUT com body JSON e retorna o response.
    [Arguments]    ${endpoint}    ${body}
    ${response}=    PUT On Session
    ...    ${SESSION_ALIAS}
    ...    ${API_PREFIX}${endpoint}
    ...    json=${body}
    ...    expected_status=any
    RETURN    ${response}

PATCH Request To
    [Documentation]    Executa uma requisição PATCH com body JSON e retorna o response.
    [Arguments]    ${endpoint}    ${body}
    ${response}=    PATCH On Session
    ...    ${SESSION_ALIAS}
    ...    ${API_PREFIX}${endpoint}
    ...    json=${body}
    ...    expected_status=any
    RETURN    ${response}

DELETE Request To
    [Documentation]    Executa uma requisição DELETE e retorna o response.
    [Arguments]    ${endpoint}
    ${response}=    DELETE On Session
    ...    ${SESSION_ALIAS}
    ...    ${API_PREFIX}${endpoint}
    ...    expected_status=any
    RETURN    ${response}

# ============================================================
# RESPONSE VALIDATION
# ============================================================

Response Status Code Should Be
    [Documentation]    Valida que o status code da response é o esperado.
    [Arguments]    ${response}    ${expected_status}
    Should Be Equal As Integers
    ...    ${response.status_code}
    ...    ${expected_status}
    ...    msg=Status code esperado: ${expected_status} | Recebido: ${response.status_code}

Response Body Should Contain Key
    [Documentation]    Valida que o body da response contém a chave informada.
    [Arguments]    ${response}    ${key}
    ${body}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${body}    ${key}

Response Field Should Equal
    [Documentation]    Valida que um campo específico do body tem o valor esperado.
    [Arguments]    ${response}    ${field}    ${expected_value}
    ${body}=    Set Variable    ${response.json()}
    ${actual_value}=    Get From Dictionary    ${body}    ${field}
    Should Be Equal As Strings    ${actual_value}    ${expected_value}

Response Field Should Not Be Empty
    [Documentation]    Valida que um campo do body não está vazio ou nulo.
    [Arguments]    ${response}    ${field}
    ${body}=    Set Variable    ${response.json()}
    ${value}=   Get From Dictionary    ${body}    ${field}
    Should Not Be Empty    ${value}

Response Data List Should Not Be Empty
    [Documentation]    Valida que o campo "data" da response contém itens.
    [Arguments]    ${response}
    ${body}=    Set Variable    ${response.json()}
    ${data}=    Get From Dictionary    ${body}    data
    Should Not Be Empty    ${data}

Get Response Field Value
    [Documentation]    Retorna o valor de um campo específico do response body.
    [Arguments]    ${response}    ${field}
    ${body}=    Set Variable    ${response.json()}
    ${value}=   Get From Dictionary    ${body}    ${field}
    RETURN    ${value}
