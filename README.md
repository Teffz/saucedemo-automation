# 🤖 Automation Framework — SauceDemo & ReqRes

<div align="center">

![Robot Framework](https://img.shields.io/badge/Robot%20Framework-7.1.1-brightgreen?logo=robotframework&logoColor=white)
![Browser Library](https://img.shields.io/badge/Browser%20Library-18.x-blue?logo=playwright&logoColor=white)
![RequestsLibrary](https://img.shields.io/badge/RequestsLibrary-0.9.x-orange)
![Python](https://img.shields.io/badge/Python-3.11+-yellow?logo=python&logoColor=white)
![Allure](https://img.shields.io/badge/Allure%20Report-2.x-blueviolet)
![CI](https://img.shields.io/badge/CI-GitHub%20Actions-black?logo=githubactions&logoColor=white)

**Projeto de automação de testes cobrindo WEB e API com Robot Framework.**  
Desenvolvido como portfólio técnico demonstrando organização, boas práticas e maturidade em QA Automation.

</div>

---

## 📋 Índice

- [Sobre o Projeto](#-sobre-o-projeto)
- [Tecnologias Utilizadas](#-tecnologias-utilizadas)
- [Arquitetura e Decisões Técnicas](#-arquitetura-e-decisões-técnicas)
- [Estrutura de Pastas](#-estrutura-de-pastas)
- [Como Instalar](#-como-instalar)
- [Como Executar](#-como-executar)
- [Cenários Automatizados](#-cenários-automatizados)
- [Allure Report](#-allure-report)
- [Melhorias Futuras](#-melhorias-futuras)

---

## 💡 Sobre o Projeto

Framework de automação desenvolvido com foco em **organização, legibilidade e manutenibilidade**, seguindo o padrão **Page Object Model (POM)** adaptado para Robot Framework com separação clara de responsabilidades em camadas.

O projeto automatiza:

- **WEB:** Fluxos críticos do e-commerce [SauceDemo](https://www.saucedemo.com) — login, carrinho e checkout.
- **API:** Operações CRUD completas na API pública [ReqRes](https://reqres.in) — GET, POST, PUT, PATCH e DELETE.
- **Data Driven:** Cenários parametrizados com múltiplas massas de dados via Test Template.

> ⚠️ Os sites utilizados são públicos e disponibilizados exclusivamente para fins de estudo e prática de automação.

---

## 🛠 Tecnologias Utilizadas

| Tecnologia | Versão | Decisão |
|---|---|---|
| [Robot Framework](https://robotframework.org/) | 7.1.1 | Framework base — sintaxe legível, fácil manutenção e adoção pela equipe |
| [Browser Library](https://robotframework-browser.org/) | 18.x | Substitui SeleniumLibrary — baseada em Playwright, mais estável e rápida |
| [RequestsLibrary](https://github.com/MarketSquare/robotframework-requests) | 0.9.x | Padrão de mercado para automação REST em Robot Framework |
| [Allure Report](https://allurereport.org/) | 2.x | Relatórios visuais e interativos, mais adequados para apresentação a stakeholders |
| Python | 3.11+ | Linguagem base do framework |
| GitHub Actions | — | CI/CD nativo do GitHub, sem custo adicional |

---

## 🏗 Arquitetura e Decisões Técnicas

### Visão geral das camadas

```
┌─────────────────────────────────────────────────┐
│                  TEST LAYER                      │
│     tests/web/          tests/api/               │
│  (Cenários, Tags, Documentação, Templates DDT)   │
└────────────────────┬────────────────────────────┘
                     │ usa
┌────────────────────▼────────────────────────────┐
│              KEYWORDS LAYER                      │
│           resources/keywords/                    │
│     (Fluxos de negócio reutilizáveis)            │
└────────────────────┬────────────────────────────┘
                     │ usa
┌────────────────────▼────────────────────────────┐
│             PAGE OBJECTS LAYER                   │
│             resources/pages/                     │
│    (Seletores + Keywords de baixo nível de UI)   │
└────────────────────┬────────────────────────────┘
                     │ usa
┌────────────────────▼────────────────────────────┐
│                 DATA LAYER                       │
│               data/*.py                          │
│      (Massa de dados e constantes centralizadas) │
└─────────────────────────────────────────────────┘
```

### Por que essa estrutura?

**Page Object Model (POM)**
Seletores de UI ficam nos page objects. Quando o sistema muda um seletor, alteramos em um único lugar — não em dezenas de testes. Isso reduz drasticamente o custo de manutenção.

**Separação entre Keywords e Page Objects**
Page objects cuidam de "como clicar" e "onde está o elemento". Keywords de alto nível cuidam de "qual é o fluxo de negócio". Essa separação permite reutilizar keywords em múltiplos testes sem duplicação.

**Data Layer centralizado**
Credenciais, mensagens de erro esperadas e payloads de API ficam em arquivos Python separados. Facilita a troca de ambiente (dev/hml/prod) e evita valores hardcoded espalhados nos testes.

**Por que Browser Library em vez de SeleniumLibrary?**
Browser Library é baseada em Playwright, que oferece auto-wait nativo (sem `Sleep`), execução mais estável e suporte moderno a SPAs. Para novos projetos, é a escolha mais adequada.

**Data Driven Testing com Test Template**
Em vez de duplicar cenários para cada variação de dado, o Template executa o mesmo fluxo com diferentes entradas. O resultado é um código menor, mais fácil de manter e mais simples de expandir com novos casos.

**Allure Report**
O report padrão do Robot Framework é funcional, mas o Allure gera relatórios visuais e interativos mais adequados para apresentação a times e stakeholders.

---

## 📁 Estrutura de Pastas

```
saucedemo-automation/
│
├── 📂 tests/
│   ├── 📂 web/
│   │   ├── login_tests.robot         # Testes de login e logout
│   │   ├── login_ddt_tests.robot     # Login Data Driven (Test Template)
│   │   ├── cart_tests.robot          # Testes de carrinho
│   │   └── checkout_tests.robot      # Testes de checkout
│   └── 📂 api/
│       ├── users_tests.robot         # Testes CRUD /users
│       └── users_ddt_tests.robot     # API Data Driven (Test Template)
│
├── 📂 resources/
│   ├── 📂 pages/
│   │   ├── login_page.robot
│   │   ├── inventory_page.robot
│   │   ├── cart_page.robot
│   │   └── checkout_page.robot
│   └── 📂 keywords/
│       ├── web_keywords.robot        # Fluxos WEB reutilizáveis
│       └── api_keywords.robot        # Helpers de requisição e validação
│
├── 📂 data/
│   ├── web_test_data.py              # Massa de dados WEB
│   └── api_test_data.py              # Massa de dados API
│
├── 📂 reports/                       # Gerado na execução (gitignored)
│   ├── allure-results/
│   ├── allure-report/
│   └── robot/
│
├── 📂 .github/
│   └── 📂 workflows/
│       └── ci.yml                    # Pipeline CI/CD
│
├── run_tests.sh                      # Script de execução (Linux/macOS)
├── run_tests.bat                     # Script de execução (Windows)
├── .gitignore
├── requirements.txt
└── README.md
```

---

## ⚙️ Como Instalar

### Pré-requisitos

- Python 3.11+
- [Allure CLI](https://allurereport.org/docs/install/) (para visualizar relatórios)

### Passo a passo

**1. Clone o repositório**
```bash
git clone https://github.com/seu-usuario/saucedemo-automation.git
cd saucedemo-automation
```

**2. Crie e ative o ambiente virtual**
```bash
# Windows
python -m venv venv
venv\Scripts\activate

# Linux / macOS
python -m venv venv
source venv/bin/activate
```

**3. Instale as dependências**
```bash
pip install -r requirements.txt
```

**4. Inicialize o Browser Library**
```bash
rfbrowser init
```

**5. Instale o Allure CLI**
```bash
# macOS
brew install allure

# Windows (via Scoop)
scoop install allure

# Linux
sudo apt-get install allure
```

---

## ▶️ Como Executar

### Usando os scripts prontos

```bash
# Linux / macOS
bash run_tests.sh all        # Todos os testes
bash run_tests.sh web        # Só testes WEB
bash run_tests.sh api        # Só testes API
bash run_tests.sh smoke      # Só smoke tests
bash run_tests.sh regression # Só regression tests
bash run_tests.sh ddt        # Só Data Driven tests

# Windows
run_tests.bat all
run_tests.bat smoke
```

### Usando Robot Framework diretamente

```bash
# Todos os testes com Allure
robot --listener allure_robotframework:reports/allure-results \
      --outputdir reports/robot \
      tests/

# Por tag
robot --include smoke tests/
robot --include regression tests/
robot --include ddt tests/
robot --include api AND get tests/

# Arquivo específico
robot tests/web/login_tests.robot
robot tests/api/users_tests.robot
```

### Visualizar Allure Report

```bash
allure generate reports/allure-results --clean -o reports/allure-report
allure open reports/allure-report
```

---

## ✅ Cenários Automatizados

### 🌐 WEB — SauceDemo (27 testes)

| ID | Descrição | Tags |
|---|---|---|
| CT-WEB-001 | Login com credenciais válidas deve redirecionar para inventário | smoke, login, positive |
| CT-WEB-002 | Login válido deve exibir a listagem de produtos | regression, login, positive |
| CT-WEB-003 | Login com senha incorreta deve exibir mensagem de erro | smoke, login, negative |
| CT-WEB-004 | Login com usuário inexistente deve exibir mensagem de erro | regression, login, negative |
| CT-WEB-005 | Login com usuário bloqueado deve exibir mensagem de bloqueio | regression, login, negative |
| CT-WEB-006 | Login sem username deve exibir erro de campo obrigatório | regression, login, negative |
| CT-WEB-007 | Login sem senha deve exibir erro de campo obrigatório | regression, login, negative |
| CT-WEB-008 | Logout deve redirecionar para a tela de login | smoke, login, logout, positive |
| CT-WEB-009 | Adicionar produto deve atualizar o badge do carrinho | smoke, cart, positive |
| CT-WEB-010 | Adicionar dois produtos deve exibir badge com valor 2 | regression, cart, positive |
| CT-WEB-011 | Produto adicionado deve aparecer na página do carrinho | smoke, cart, positive |
| CT-WEB-012 | Carrinho deve exibir múltiplos produtos adicionados | regression, cart, positive |
| CT-WEB-013 | Remover produto deve limpar o badge do carrinho | smoke, cart, negative |
| CT-WEB-014 | Remover produto do carrinho deve atualizar a listagem | regression, cart, negative |
| CT-WEB-015 | Remover um de dois produtos deve manter badge com valor 1 | regression, cart, negative |
| CT-WEB-016 | Continue shopping deve redirecionar para o inventário | regression, cart, positive |
| CT-WEB-017 | Checkout completo deve exibir confirmação de pedido | smoke, checkout, positive |
| CT-WEB-018 | Step 2 do checkout deve exibir resumo do pedido | regression, checkout, positive |
| CT-WEB-019 | Checkout sem First Name deve exibir erro | regression, checkout, negative |
| CT-WEB-020 | Checkout sem Last Name deve exibir erro | regression, checkout, negative |
| CT-WEB-021 | Checkout sem CEP deve exibir erro | regression, checkout, negative |
| CT-WEB-022 | Cancelar checkout deve retornar ao carrinho | regression, checkout, negative |
| CT-DDT-001 | Login inválido — 6 cenários via Data Driven | regression, login, negative, ddt |
| CT-DDT-002 | Login válido por tipo de usuário — 2 cenários via Data Driven | regression, login, positive, ddt |

### 🔌 API — ReqRes (23 testes)

| ID | Descrição | Tags |
|---|---|---|
| CT-API-001 | GET lista de usuários — status 200 e lista não vazia | smoke, api, get, positive |
| CT-API-002 | GET usuário específico — status 200 e dados corretos | smoke, api, get, positive |
| CT-API-003 | GET usuário inexistente — status 404 | smoke, api, get, negative |
| CT-API-004 | GET página 2 — status 200 | regression, api, get, positive |
| CT-API-005 | GET lista deve retornar campo support | regression, api, get, positive |
| CT-API-006 | POST criar usuário — status 201 e body com ID | smoke, api, post, positive |
| CT-API-007 | POST criar usuário — retorna dados enviados | regression, api, post, positive |
| CT-API-008 | POST criar usuário — ID não vazio | regression, api, post, positive |
| CT-API-009 | PUT atualizar usuário — status 200 e dados atualizados | smoke, api, put, positive |
| CT-API-010 | PUT atualizar usuário — retorna updatedAt | regression, api, put, positive |
| CT-API-011 | PATCH atualizar parcialmente — status 200 | smoke, api, patch, positive |
| CT-API-012 | PATCH atualizar usuário — retorna updatedAt | regression, api, patch, positive |
| CT-API-013 | DELETE usuário — status 204 sem body | smoke, api, delete, positive |
| CT-API-014 | DELETE usuário — body vazio | regression, api, delete, positive |
| CT-DDT-003 | Validar status code GET para 5 IDs — Data Driven | regression, api, get, ddt |
| CT-DDT-004 | Criar 5 usuários com perfis diferentes — Data Driven | regression, api, post, ddt |
| CT-DDT-005 | Atualizar cargo do usuário com 4 valores — Data Driven | regression, api, put, ddt |

**Total: 50 cenários automatizados**

---

## 📊 Allure Report

O Allure gera relatórios interativos com visão geral da execução, histórico de falhas e detalhes de cada passo.

Após executar, rode:
```bash
allure open reports/allure-report
```

---

## 🚀 Melhorias Futuras

- [ ] **Múltiplos ambientes** — Gerenciar dev/hml/prod via variáveis de ambiente
- [ ] **Execução paralela** — Implementar `pabot` para reduzir tempo de execução
- [ ] **Docker** — Containerizar para execução sem dependências locais
- [ ] **Cross-browser** — Ampliar para Firefox e WebKit além de Chromium
- [ ] **Notificações** — Enviar resultado ao Slack/Teams ao término do pipeline
- [ ] **Validação de schema JSON** — Garantir contrato de API com JSON Schema

---

## 👨‍💻 Autor

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Conectar-blue?logo=linkedin)](](https://www.linkedin.com/in/sthefane-nns/))
[![GitHub](https://img.shields.io/badge/GitHub-Perfil-black?logo=github)](https://github.com/Teffz)

---

<div align="center">⭐ Se este projeto foi útil, deixe uma estrela!</div>
