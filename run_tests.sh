#!/bin/bash
# ==============================================================
# run_tests.sh — Script de execução com geração de Allure Report
# Uso: bash run_tests.sh [all|web|api|smoke|regression|ddt]
# ==============================================================

SUITE=${1:-all}
ALLURE_RESULTS="reports/allure-results"
ALLURE_REPORT="reports/allure-report"
ROBOT_OUTPUTS="reports/robot"

mkdir -p $ALLURE_RESULTS $ALLURE_REPORT $ROBOT_OUTPUTS

echo ""
echo "========================================="
echo "  🤖 Robot Framework — Automation Suite  "
echo "========================================="
echo "  Executando: $SUITE"
echo "========================================="
echo ""

run_robot() {
    robot \
        --listener allure_robotframework:$ALLURE_RESULTS \
        --outputdir $ROBOT_OUTPUTS \
        --loglevel INFO \
        "$@"
}

case $SUITE in
    all)
        echo "▶  Executando todos os testes..."
        run_robot tests/
        ;;
    web)
        echo "▶  Executando testes WEB..."
        run_robot tests/web/
        ;;
    api)
        echo "▶  Executando testes API..."
        run_robot tests/api/
        ;;
    smoke)
        echo "▶  Executando testes Smoke..."
        run_robot --include smoke tests/
        ;;
    regression)
        echo "▶  Executando testes Regression..."
        run_robot --include regression tests/
        ;;
    ddt)
        echo "▶  Executando testes Data Driven..."
        run_robot --include ddt tests/
        ;;
    *)
        echo "❌ Opção inválida: $SUITE"
        echo "   Use: all | web | api | smoke | regression | ddt"
        exit 1
        ;;
esac

echo ""
echo "========================================="
echo "  📊 Gerando Allure Report..."
echo "========================================="
echo ""

allure generate $ALLURE_RESULTS --clean -o $ALLURE_REPORT

echo ""
echo "========================================="
echo "  ✅ Relatório gerado em: $ALLURE_REPORT "
echo "  Execute: allure open $ALLURE_REPORT    "
echo "========================================="
echo ""
