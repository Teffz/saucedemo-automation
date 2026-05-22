*** Settings ***
Documentation     Testes de API — ReqRes Users
...               Cobre os verbos HTTP (GET, POST, PUT, PATCH, DELETE) para o recurso /users.
...               Valida status codes, campos obrigatórios e integridade dos dados.
Resource          ../../resources/keywords/api_keywords.robot
Variables         ../../data/api_test_data.py
Suite Setup       Create API Session

*** Test Cases ***

# ==============================================================
# GET — LISTAR E BUSCAR USUÁRIOS
# ==============================================================

CT-API-001: GET lista de usuários deve retornar status 200 e lista não vazia
    [Documentation]    Verifica que o endpoint GET /users retorna status 200 e
    ...                uma lista com ao menos um usuário na página 1.
    [Tags]             smoke    api    get    positive
    ${response}=    GET Request To    ${USERS_LIST_ENDPOINT}    ${USERS_PAGE_1}
    Response Status Code Should Be    ${response}    ${STATUS_OK}
    Response Body Should Contain Key    ${response}    data
    Response Data List Should Not Be Empty    ${response}

CT-API-002: GET usuário específico deve retornar status 200 e dados corretos
    [Documentation]    Verifica que GET /users/{id} retorna os dados do usuário com ID 2.
    [Tags]             smoke    api    get    positive
    ${response}=    GET Request To    ${USERS_ENDPOINT}/${VALID_USER_ID}
    Response Status Code Should Be    ${response}    ${STATUS_OK}
    Response Body Should Contain Key    ${response}    data
    ${user_id}=    Get Response Field Value    ${response}    data
    Should Not Be Empty    ${user_id}

CT-API-003: GET usuário inexistente deve retornar status 404
    [Documentation]    Verifica que ao buscar um ID inexistente a API retorna 404.
    [Tags]             smoke    api    get    negative
    ${response}=    GET Request To    ${USERS_ENDPOINT}/${INVALID_USER_ID}
    Response Status Code Should Be    ${response}    ${STATUS_NOT_FOUND}

CT-API-004: GET lista de usuários página 2 deve retornar status 200
    [Documentation]    Verifica que a paginação funciona e a página 2 retorna dados.
    [Tags]             regression    api    get    positive
    ${response}=    GET Request To    ${USERS_LIST_ENDPOINT}    ${USERS_PAGE_2}
    Response Status Code Should Be    ${response}    ${STATUS_OK}
    Response Body Should Contain Key    ${response}    data
    Response Data List Should Not Be Empty    ${response}

CT-API-005: GET lista deve retornar campo de suporte (support)
    [Documentation]    Verifica que o response body contém o campo "support"
    ...                conforme contrato da API.
    [Tags]             regression    api    get    positive
    ${response}=    GET Request To    ${USERS_LIST_ENDPOINT}    ${USERS_PAGE_1}
    Response Status Code Should Be    ${response}    ${STATUS_OK}
    Response Body Should Contain Key    ${response}    support

# ==============================================================
# POST — CRIAR USUÁRIO
# ==============================================================

CT-API-006: POST criar usuário deve retornar status 201 e body com ID
    [Documentation]    Verifica que criar um usuário retorna status 201 (Created)
    ...                e o body contém o ID gerado e os dados enviados.
    [Tags]             smoke    api    post    positive
    ${response}=    POST Request To    ${USERS_ENDPOINT}    ${CREATE_USER_PAYLOAD}
    Response Status Code Should Be    ${response}    ${STATUS_CREATED}
    Response Body Should Contain Key    ${response}    id
    Response Body Should Contain Key    ${response}    createdAt

CT-API-007: POST criar usuário deve retornar o nome enviado no body
    [Documentation]    Verifica que os dados enviados (name e job) são refletidos
    ...                corretamente no body da response de criação.
    [Tags]             regression    api    post    positive
    ${response}=    POST Request To    ${USERS_ENDPOINT}    ${CREATE_USER_PAYLOAD}
    Response Status Code Should Be    ${response}    ${STATUS_CREATED}
    Response Field Should Equal    ${response}    name    ${CREATE_USER_PAYLOAD}[name]
    Response Field Should Equal    ${response}    job     ${CREATE_USER_PAYLOAD}[job]

CT-API-008: POST criar usuário deve retornar ID gerado não vazio
    [Documentation]    Verifica que o ID retornado na criação não é vazio,
    ...                garantindo que o recurso foi criado com identificador válido.
    [Tags]             regression    api    post    positive
    ${response}=    POST Request To    ${USERS_ENDPOINT}    ${CREATE_USER_PAYLOAD}
    Response Status Code Should Be    ${response}    ${STATUS_CREATED}
    Response Field Should Not Be Empty    ${response}    id

# ==============================================================
# PUT — ATUALIZAR USUÁRIO (COMPLETO)
# ==============================================================

CT-API-009: PUT atualizar usuário deve retornar status 200 e dados atualizados
    [Documentation]    Verifica que a atualização completa do usuário retorna 200
    ...                e os campos atualizados no body da response.
    [Tags]             smoke    api    put    positive
    ${response}=    PUT Request To
    ...    ${USERS_ENDPOINT}/${VALID_USER_ID}
    ...    ${UPDATE_USER_PAYLOAD}
    Response Status Code Should Be    ${response}    ${STATUS_OK}
    Response Field Should Equal    ${response}    name    ${UPDATE_USER_PAYLOAD}[name]
    Response Field Should Equal    ${response}    job     ${UPDATE_USER_PAYLOAD}[job]

CT-API-010: PUT atualizar usuário deve retornar campo updatedAt
    [Documentation]    Verifica que o response de atualização contém o campo
    ...                "updatedAt", indicando a data/hora de modificação.
    [Tags]             regression    api    put    positive
    ${response}=    PUT Request To
    ...    ${USERS_ENDPOINT}/${VALID_USER_ID}
    ...    ${UPDATE_USER_PAYLOAD}
    Response Status Code Should Be    ${response}    ${STATUS_OK}
    Response Body Should Contain Key    ${response}    updatedAt
    Response Field Should Not Be Empty    ${response}    updatedAt

# ==============================================================
# PATCH — ATUALIZAR USUÁRIO (PARCIAL)
# ==============================================================

CT-API-011: PATCH atualizar parcialmente usuário deve retornar status 200
    [Documentation]    Verifica que a atualização parcial (PATCH) funciona corretamente,
    ...                retornando status 200 e o campo alterado no body.
    [Tags]             smoke    api    patch    positive
    ${response}=    PATCH Request To
    ...    ${USERS_ENDPOINT}/${VALID_USER_ID}
    ...    ${PATCH_USER_PAYLOAD}
    Response Status Code Should Be    ${response}    ${STATUS_OK}
    Response Field Should Equal    ${response}    job    ${PATCH_USER_PAYLOAD}[job]

CT-API-012: PATCH atualizar usuário deve retornar updatedAt
    [Documentation]    Verifica que o PATCH também retorna o campo "updatedAt".
    [Tags]             regression    api    patch    positive
    ${response}=    PATCH Request To
    ...    ${USERS_ENDPOINT}/${VALID_USER_ID}
    ...    ${PATCH_USER_PAYLOAD}
    Response Status Code Should Be    ${response}    ${STATUS_OK}
    Response Body Should Contain Key    ${response}    updatedAt

# ==============================================================
# DELETE — REMOVER USUÁRIO
# ==============================================================

CT-API-013: DELETE usuário deve retornar status 204 sem body
    [Documentation]    Verifica que ao deletar um usuário a API retorna 204 (No Content),
    ...                indicando exclusão bem-sucedida sem body na resposta.
    [Tags]             smoke    api    delete    positive
    ${response}=    DELETE Request To    ${USERS_ENDPOINT}/${VALID_USER_ID}
    Response Status Code Should Be    ${response}    ${STATUS_NO_CONTENT}

CT-API-014: DELETE usuário deve retornar body vazio
    [Documentation]    Verifica que o body da response de delete é vazio,
    ...                conforme padrão REST para operações de exclusão.
    [Tags]             regression    api    delete    positive
    ${response}=    DELETE Request To    ${USERS_ENDPOINT}/${VALID_USER_ID}
    Response Status Code Should Be    ${response}    ${STATUS_NO_CONTENT}
    ${body}=    Convert To String    ${response.text}
    Should Be Empty    ${body}
