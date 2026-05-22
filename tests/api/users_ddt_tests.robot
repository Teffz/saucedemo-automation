*** Settings ***
Documentation     Testes Data Driven — API ReqRes
...               Valida múltiplos cenários de API usando Test Template.
...               Demonstra validação de contrato para diferentes endpoints
...               e combinações de status code esperado.
Resource          ../../resources/keywords/api_keywords.robot
Variables         ../../data/api_test_data.py
Suite Setup       Create API Session

*** Test Cases ***

# ==============================================================
# DATA DRIVEN — STATUS CODES
# ==============================================================

CT-DDT-003: Validar status code para GET de usuários — ID ${user_id}
    [Documentation]    Valida o status code para diferentes IDs de usuário.
    ...                IDs existentes retornam 200, inexistentes retornam 404.
    [Tags]             regression    api    get    ddt
    [Template]         Validate GET User Status Code
    # USER_ID    EXPECTED_STATUS
    1            ${STATUS_OK}
    2            ${STATUS_OK}
    3            ${STATUS_OK}
    9999         ${STATUS_NOT_FOUND}
    0            ${STATUS_NOT_FOUND}

CT-DDT-004: Criar usuários com diferentes perfis — ${job_title}
    [Documentation]    Valida a criação de usuários com diferentes cargos/perfis.
    ...                Todos devem retornar 201 com os dados enviados refletidos.
    [Tags]             regression    api    post    ddt
    [Template]         Validate Create User With Profile
    # NAME                    JOB
    Ana Souza                 QA Analyst
    Carlos Mendes             Backend Developer
    Maria Lima                Product Owner
    João Ferreira             Scrum Master
    Paula Costa               DevOps Engineer

CT-DDT-005: Atualizar usuário com diferentes cargos — ${new_job}
    [Documentation]    Valida a atualização de cargo para o usuário ID 2
    ...                com diferentes valores, verificando que updatedAt é retornado.
    [Tags]             regression    api    put    ddt
    [Template]         Validate Update User Job
    # NEW_JOB
    Junior QA Engineer
    Mid-Level QA Engineer
    Senior QA Engineer
    QA Tech Lead

*** Keywords ***

Validate GET User Status Code
    [Documentation]    Keyword do Template: GET /users/{id} e valida status code esperado.
    [Arguments]        ${user_id}    ${expected_status}
    ${response}=    GET Request To    ${USERS_ENDPOINT}/${user_id}
    Response Status Code Should Be    ${response}    ${expected_status}

Validate Create User With Profile
    [Documentation]    Keyword do Template: cria usuário e valida dados retornados.
    [Arguments]        ${name}    ${job}
    ${payload}=    Create Dictionary    name=${name}    job=${job}
    ${response}=    POST Request To    ${USERS_ENDPOINT}    ${payload}
    Response Status Code Should Be    ${response}    ${STATUS_CREATED}
    Response Field Should Equal       ${response}    name    ${name}
    Response Field Should Equal       ${response}    job     ${job}
    Response Field Should Not Be Empty    ${response}    id
    Response Field Should Not Be Empty    ${response}    createdAt

Validate Update User Job
    [Documentation]    Keyword do Template: atualiza cargo do usuário e valida response.
    [Arguments]        ${new_job}
    ${payload}=    Create Dictionary    name=João Silva    job=${new_job}
    ${response}=    PUT Request To    ${USERS_ENDPOINT}/${VALID_USER_ID}    ${payload}
    Response Status Code Should Be      ${response}    ${STATUS_OK}
    Response Field Should Equal         ${response}    job    ${new_job}
    Response Field Should Not Be Empty  ${response}    updatedAt
