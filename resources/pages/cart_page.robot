*** Settings ***
Documentation    Page Object — SauceDemo Cart Page
...              Contém seletores e keywords da página do carrinho de compras.
Library          Browser

*** Variables ***
${CART_URL}                  https://www.saucedemo.com/cart.html
${CART_TITLE}                css=.title
${CART_ITEM_LIST}            css=.cart_list
${CART_ITEM_NAME}            css=.inventory_item_name
${CART_ITEM_PRICE}           css=.inventory_item_price
${CART_QUANTITY}             css=.cart_quantity
${CONTINUE_SHOPPING_BTN}     css=[data-test="continue-shopping"]
${CHECKOUT_BTN}              css=[data-test="checkout"]
${REMOVE_BACKPACK_CART}      css=[data-test="remove-sauce-labs-backpack"]
${REMOVE_BIKE_LIGHT_CART}    css=[data-test="remove-sauce-labs-bike-light"]

*** Keywords ***
Cart Page Should Be Loaded
    [Documentation]    Verifica que a página do carrinho foi carregada.
    Wait For Elements State    ${CART_ITEM_LIST}    visible    timeout=10s
    ${title}=    Get Text    ${CART_TITLE}
    Should Be Equal As Strings    ${title}    Your Cart

Cart Should Contain Item
    [Documentation]    Verifica que um produto específico está presente no carrinho.
    [Arguments]    ${product_name}
    ${count}=    Get Element Count    ${CART_ITEM_NAME}
    Should Be True    ${count} > 0
    ${item_text}=    Get Text    css=.inventory_item_name >> nth=0
    Should Contain    ${item_text}    ${product_name}

Cart Should Be Empty
    [Documentation]    Verifica que não há itens no carrinho.
    ${items}=    Get Element Count    ${CART_ITEM_NAME}
    Should Be Equal As Integers    ${items}    0

Remove Backpack From Cart Page
    [Documentation]    Remove o produto Backpack estando na página do carrinho.
    Click    ${REMOVE_BACKPACK_CART}

Remove Bike Light From Cart Page
    [Documentation]    Remove o produto Bike Light estando na página do carrinho.
    Click    ${REMOVE_BIKE_LIGHT_CART}

Click Continue Shopping
    [Documentation]    Clica em "Continue Shopping" para voltar à listagem de produtos.
    Click    ${CONTINUE_SHOPPING_BTN}

Click Checkout Button
    [Documentation]    Clica no botão Checkout para iniciar o fluxo de finalização.
    Click    ${CHECKOUT_BTN}

Get Cart Items Count
    [Documentation]    Retorna a quantidade de itens presentes no carrinho.
    ${count}=    Get Element Count    ${CART_ITEM_NAME}
    RETURN    ${count}
