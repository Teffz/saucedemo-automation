# ==============================================================
# API Test Data — ReqRes
# Arquivo centralizado com massa de dados para testes de API.
# ==============================================================

# --- Endpoints ---
USERS_ENDPOINT = "/users"
USERS_LIST_ENDPOINT = "/users"
REGISTER_ENDPOINT = "/register"
LOGIN_ENDPOINT = "/login"

# --- IDs de usuários existentes ---
VALID_USER_ID = "2"
INVALID_USER_ID = "9999"

# --- Parâmetros de listagem ---
USERS_PAGE_1 = {"page": "1"}
USERS_PAGE_2 = {"page": "2"}

# --- Payload: criar usuário ---
CREATE_USER_PAYLOAD = {
    "name": "João Silva",
    "job": "QA Automation Engineer"
}

# --- Payload: atualizar usuário (PUT) ---
UPDATE_USER_PAYLOAD = {
    "name": "João Silva",
    "job": "Senior QA Automation Engineer"
}

# --- Payload: atualizar parcialmente (PATCH) ---
PATCH_USER_PAYLOAD = {
    "job": "Lead QA Engineer"
}

# --- Payload: registro bem-sucedido ---
REGISTER_SUCCESS_PAYLOAD = {
    "email": "eve.holt@reqres.in",
    "password": "pistol"
}

# --- Payload: registro sem senha (deve falhar) ---
REGISTER_MISSING_PASSWORD_PAYLOAD = {
    "email": "sydney@fife"
}

# --- Status codes esperados ---
STATUS_OK = 200
STATUS_CREATED = 201
STATUS_NO_CONTENT = 204
STATUS_NOT_FOUND = 404
STATUS_BAD_REQUEST = 400

# --- Campos obrigatórios no response body ---
USER_REQUIRED_FIELDS = ["data", "support"]
USER_DATA_FIELDS = ["id", "email", "first_name", "last_name", "avatar"]
CREATE_RESPONSE_FIELDS = ["name", "job", "id", "createdAt"]
UPDATE_RESPONSE_FIELDS = ["name", "job", "updatedAt"]
