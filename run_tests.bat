@echo off
REM ==============================================================
REM run_tests.bat — Script de execução com geração de Allure Report
REM Uso: run_tests.bat [all|web|api|smoke|regression|ddt]
REM ==============================================================

SET SUITE=%1
IF "%SUITE%"=="" SET SUITE=all

SET ALLURE_RESULTS=reports\allure-results
SET ALLURE_REPORT=reports\allure-report
SET ROBOT_OUTPUTS=reports\robot

IF NOT EXIST %ALLURE_RESULTS% mkdir %ALLURE_RESULTS%
IF NOT EXIST %ALLURE_REPORT%  mkdir %ALLURE_REPORT%
IF NOT EXIST %ROBOT_OUTPUTS%  mkdir %ROBOT_OUTPUTS%

echo.
echo =========================================
echo   Robot Framework -- Automation Suite
echo =========================================
echo   Executando: %SUITE%
echo =========================================
echo.

IF "%SUITE%"=="all" (
    robot --listener allure_robotframework:%ALLURE_RESULTS% --outputdir %ROBOT_OUTPUTS% --loglevel INFO tests\
) ELSE IF "%SUITE%"=="web" (
    robot --listener allure_robotframework:%ALLURE_RESULTS% --outputdir %ROBOT_OUTPUTS% --loglevel INFO tests\web\
) ELSE IF "%SUITE%"=="api" (
    robot --listener allure_robotframework:%ALLURE_RESULTS% --outputdir %ROBOT_OUTPUTS% --loglevel INFO tests\api\
) ELSE IF "%SUITE%"=="smoke" (
    robot --listener allure_robotframework:%ALLURE_RESULTS% --outputdir %ROBOT_OUTPUTS% --include smoke tests\
) ELSE IF "%SUITE%"=="regression" (
    robot --listener allure_robotframework:%ALLURE_RESULTS% --outputdir %ROBOT_OUTPUTS% --include regression tests\
) ELSE IF "%SUITE%"=="ddt" (
    robot --listener allure_robotframework:%ALLURE_RESULTS% --outputdir %ROBOT_OUTPUTS% --include ddt tests\
) ELSE (
    echo Opcao invalida: %SUITE%
    echo Use: all, web, api, smoke, regression ou ddt
    exit /b 1
)

echo.
echo =========================================
echo   Gerando Allure Report...
echo =========================================

allure generate %ALLURE_RESULTS% --clean -o %ALLURE_REPORT%

echo.
echo =========================================
echo   Relatorio gerado em: %ALLURE_REPORT%
echo   Execute: allure open %ALLURE_REPORT%
echo =========================================
echo.
