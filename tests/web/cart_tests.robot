*** Settings ***
Documentation     Testes de Carrinho — SauceDemo
...               Cobre os fluxos de adicionar e remover produtos do carrinho de compras.
Resource          ../../resources/keywords/web_keywords.robot
Resource          ../../resources/pages/inventory_page.robot
Resource          ../../resources/pages/cart_page.robot
Variables         ../../data/web_test_data.py
Test Setup        Run Keywords
...               Open Browser Session
...               AND    Do Login With Valid Credentials    ${VALID_USERNAME}    ${VALID_PASSWORD}
Test Teardown     Run Keywords
...               Run Keyword If Test Failed    Take Screenshot On Failure
...               AND    Close Browser Session

*** Test Cases ***

CT-WEB-009: Adicionar um produto ao carrinho deve atualizar o badge
    [Documentation]    Verifica que ao adicionar um produto o badge do carrinho
    ...                é atualizado com a quantidade correta.
    [Tags]             smoke    cart    positive
    Add Sauce Labs Backpack To Cart
    Cart Badge Should Show    1

CT-WEB-010: Adicionar dois produtos ao carrinho deve exibir badge com valor 2
    [Documentation]    Verifica que ao adicionar dois produtos o badge exibe "2".
    [Tags]             regression    cart    positive
    Add Multiple Products To Cart
    Cart Badge Should Show    2

CT-WEB-011: Produto adicionado deve aparecer na página do carrinho
    [Documentation]    Verifica que o produto adicionado está presente na listagem
    ...                do carrinho ao navegar para a página /cart.html.
    [Tags]             smoke    cart    positive
    Add Sauce Labs Backpack To Cart
    Open Cart And Verify Item    ${PRODUCT_BACKPACK_NAME}

CT-WEB-012: Carrinho deve exibir múltiplos produtos adicionados
    [Documentation]    Verifica que dois produtos adicionados aparecem corretamente
    ...                na página do carrinho.
    [Tags]             regression    cart    positive
    Add Multiple Products To Cart
    Navigate To Cart
    Cart Page Should Be Loaded
    Cart Should Contain Item    ${PRODUCT_BACKPACK_NAME}
    ${count}=    Get Cart Items Count
    Should Be Equal As Integers    ${count}    2

CT-WEB-013: Remover produto da listagem deve limpar o badge do carrinho
    [Documentation]    Verifica que após remover o único produto o badge some,
    ...                indicando carrinho vazio.
    [Tags]             smoke    cart    negative
    Add Sauce Labs Backpack To Cart
    Cart Badge Should Show    1
    Remove Product From Inventory Page
    Cart Badge Should Not Be Visible

CT-WEB-014: Remover produto do carrinho deve atualizar a listagem
    [Documentation]    Verifica que ao remover um produto na página do carrinho
    ...                a listagem é atualizada e o carrinho fica vazio.
    [Tags]             regression    cart    negative
    Add Sauce Labs Backpack To Cart
    Navigate To Cart
    Cart Page Should Be Loaded
    Remove Backpack From Cart Page
    Cart Should Be Empty

CT-WEB-015: Remover um de dois produtos deve manter badge com valor 1
    [Documentation]    Verifica que ao remover um produto de um carrinho com 2 itens
    ...                o badge é atualizado para "1".
    [Tags]             regression    cart    negative
    Add Multiple Products To Cart
    Cart Badge Should Show    2
    Remove Sauce Labs Backpack From Cart
    Cart Badge Should Show    1

CT-WEB-016: Botão continue shopping deve redirecionar para o inventário
    [Documentation]    Verifica que ao clicar em "Continue Shopping" o usuário
    ...                retorna à página de produtos.
    [Tags]             regression    cart    positive
    Add Sauce Labs Backpack To Cart
    Navigate To Cart
    Cart Page Should Be Loaded
    Click Continue Shopping
    Inventory Page Should Be Loaded
