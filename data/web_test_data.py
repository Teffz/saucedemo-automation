# ==============================================================
# Web Test Data — SauceDemo
# Arquivo centralizado com massa de dados para testes WEB.
# ==============================================================

# --- Usuários válidos ---
VALID_USERNAME = "standard_user"
VALID_PASSWORD = "secret_sauce"

LOCKED_OUT_USER = "locked_out_user"
PROBLEM_USER = "problem_user"
PERFORMANCE_GLITCH_USER = "performance_glitch_user"

# --- Credenciais inválidas ---
INVALID_USERNAME = "invalid_user_xpto"
INVALID_PASSWORD = "wrong_password_123"
EMPTY_USERNAME = ""
EMPTY_PASSWORD = ""

# --- Mensagens de erro esperadas ---
ERROR_INVALID_CREDENTIALS = "Epic sadface: Username and password do not match any user in this service"
ERROR_LOCKED_OUT = "Epic sadface: Sorry, this user has been locked out."
ERROR_USERNAME_REQUIRED = "Epic sadface: Username is required"
ERROR_PASSWORD_REQUIRED = "Epic sadface: Password is required"

# --- Produtos ---
PRODUCT_BACKPACK_NAME = "Sauce Labs Backpack"
PRODUCT_BIKE_LIGHT_NAME = "Sauce Labs Bike Light"
PRODUCT_BOLT_TSHIRT_NAME = "Sauce Labs Bolt T-Shirt"

# --- Dados de checkout ---
CHECKOUT_FIRST_NAME = "João"
CHECKOUT_LAST_NAME = "Silva"
CHECKOUT_POSTAL_CODE = "01310-100"

# --- Mensagens de confirmação ---
CHECKOUT_COMPLETE_HEADER = "Thank you for your order!"
CHECKOUT_COMPLETE_TEXT = "Your order has been dispatched"
