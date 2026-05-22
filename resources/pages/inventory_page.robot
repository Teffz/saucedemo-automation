*** Settings ***
Documentation    Page Object — SauceDemo Inventory Page (Listagem de Produtos)
...              Contém seletores e keywords da página de produtos.
Library          Browser

*** Variables ***
${INVENTORY_URL}           https://www.saucedemo.com/inventory.html
${PRODUCT_TITLE}           css=.title
${BURGER_MENU_BTN}         id=react-burger-menu-btn
${LOGOUT_LINK}             id=logout_sidebar_link
${CART_ICON}               css=.shopping_cart_link
${CART_BADGE}              css=.shopping_cart_badge
${PRODUCT_SORT_DROPDOWN}   css=[data-test="product-sort-container"]
${PRODUCT_LIST}            css=.inventory_list
${FIRST_PRODUCT_NAME}      css=.inventory_item_name >> nth=0
${FIRST_PRODUCT_PRICE}     css=.inventory_item_price >> nth=0

# Seletores dinâmicos dos botões de adicionar ao carrinho
${ADD_BACKPACK_BTN}        css=[data-test="add-to-cart-sauce-labs-backpack"]
${ADD_BIKE_LIGHT_BTN}      css=[data-test="add-to-cart-sauce-labs-bike-light"]
${ADD_BOLT_TSHIRT_BTN}     css=[data-test="add-to-cart-sauce-labs-bolt-t-shirt"]
${REMOVE_BACKPACK_BTN}     css=[data-test="remove-sauce-labs-backpack"]
${REMOVE_BIKE_LIGHT_BTN}   css=[data-test="remove-sauce-labs-bike-light"]

*** Keywords ***
Inventory Page Should Be Loaded
    [Documentation]    Verifica que a página de inventário foi carregada com sucesso.
    Wait For Elements State    ${PRODUCT_LIST}    visible    timeout=10s
    Get Title    ==    Swag Labs

Open Burger Menu
    [Documentation]    Abre o menu lateral (hamburguer).
    Click    ${BURGER_MENU_BTN}
    Wait For Elements State    ${LOGOUT_LINK}    visible    timeout=5s

Click Logout
    [Documentation]    Clica no link de logout no menu lateral.
    Click    ${LOGOUT_LINK}

Navigate To Cart
    [Documentation]    Clica no ícone do carrinho para navegar à página do carrinho.
    Click    ${CART_ICON}

Add Sauce Labs Backpack To Cart
    [Documentation]    Adiciona o produto Sauce Labs Backpack ao carrinho.
    Click    ${ADD_BACKPACK_BTN}

Add Sauce Labs Bike Light To Cart
    [Documentation]    Adiciona o produto Sauce Labs Bike Light ao carrinho.
    Click    ${ADD_BIKE_LIGHT_BTN}

Add Sauce Labs Bolt T-Shirt To Cart
    [Documentation]    Adiciona o produto Sauce Labs Bolt T-Shirt ao carrinho.
    Click    ${ADD_BOLT_TSHIRT_BTN}

Remove Sauce Labs Backpack From Cart
    [Documentation]    Remove o produto Sauce Labs Backpack do carrinho (via botão na listagem).
    Click    ${REMOVE_BACKPACK_BTN}

Remove Sauce Labs Bike Light From Cart
    [Documentation]    Remove o produto Sauce Labs Bike Light do carrinho (via botão na listagem).
    Click    ${REMOVE_BIKE_LIGHT_BTN}

Get Cart Badge Count
    [Documentation]    Retorna a quantidade exibida no badge do carrinho.
    ${count}=    Get Text    ${CART_BADGE}
    RETURN       ${count}

Cart Badge Should Not Be Visible
    [Documentation]    Verifica que o badge do carrinho não está visível (carrinho vazio).
    Wait For Elements State    ${CART_BADGE}    hidden    timeout=5s

Cart Badge Should Show
    [Documentation]    Verifica que o badge exibe a quantidade esperada.
    [Arguments]    ${expected_count}
    ${count}=     Get Cart Badge Count
    Should Be Equal As Strings    ${count}    ${expected_count}
