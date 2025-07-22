@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

:: Caminho do PlantUML
set PLANTUML_JAR=plantuml.jar

echo.
echo ========= GERADOR DE DIAGRAMAS UML =========
echo.
echo 1 - Gerar todos os diagramas
echo 2 - Gerar um arquivo específico
echo.

set /p opcao=Escolha uma opção [1 ou 2]: 

if "%opcao%"=="1" (
    echo.
    echo Gerando todos os diagramas...
    for /R ..\src %%f in (*.txt) do (
        echo Gerando: %%f
        java -jar "%PLANTUML_JAR%" "%%f" -tpng
    )
    echo.
    echo [OK] Todos os diagramas foram gerados com sucesso.
    goto fim
)

if "%opcao%"=="2" (
    echo.
    call :pedirArquivo
    goto fim
)

echo.
echo [ERRO] Opção inválida.
goto fim

:pedirArquivo
set /p nomeArquivo=Digite o nome do arquivo (sem .txt): 
set nomeArquivo=%nomeArquivo:.txt=%

set encontrado=false

for /R ..\src %%f in (*.txt) do (
    if /I "%%~nxf"=="%nomeArquivo%.txt" (
        echo Gerando: %%f
        java -jar "%PLANTUML_JAR%" "%%f" -tpng
        set encontrado=true
    )
)

if "!encontrado!"=="false" (
    echo [ERRO] Arquivo "%nomeArquivo%.txt" não encontrado.
) else (
    echo [OK] Diagrama gerado com sucesso.
)
goto :eof

:fim
echo.
pause
exit /b