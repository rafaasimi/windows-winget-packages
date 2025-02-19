@echo off
setlocal enabledelayedexpansion

:: Verifica se o winget está instalado
where winget >nul 2>nul
if %errorlevel% neq 0 (
    echo winget não encontrado.
    set /p installWinget="Deseja instalar winget? (s/n): "
    if /i "!installWinget!"=="s" (
        powershell -Command "Start-Process msstore: -ArgumentList '/pdp?productid=9NBLGGH4NNS1' -NoNewWindow -Wait"
        timeout /t 30
    ) else (
        echo winget não será instalado. Saindo do script.
        exit /b
    )
)

:: Definir a lista de pacotes para instalar
set "packages=Google.Chrome Deezer.Deezer Postman.Postman MongoDB.Compass.Full OpenJS.NodeJS.LTS Git.Git Microsoft.VisualStudioCode JetBrains.IntelliJIDEA.Community Figma.Figma Amazon.Corretto.21.JDK Amazon.Corretto.19.JDK Amazon.Corretto.11.JDK NetsdkSoftwareFZE.S3Browser dbeaver.dbeaver SmartBear.SoapUI"

:: Exibir pacotes que serão instalados
echo Os seguintes pacotes serao instalados:
for %%i in (%packages%) do (
    echo - %%i
)

echo.

:: Pedir confirmação do usuário
set /p confirm="Deseja continuar com a instalacao desses pacotes? (s/n): "
if /i "!confirm!" neq "s" (
    echo Instalação cancelada pelo usuário.
    exit /b
)

:: Instalar pacotes
set "failed_packages="
set "successful_packages="

for %%i in (%packages%) do (
    echo.
    echo Instalando %%i...
    winget install --id %%i --silent
    if !errorlevel! neq 0 (
        echo Erro ao instalar %%i
        set "failed_packages=!failed_packages! %%i"
    ) else (
        echo Sucesso ao instalar %%i
        set "successful_packages=!successful_packages! %%i"
    )
)

:: Lista pacotes que falharam na instalação
if defined failed_packages (
    echo.
    echo Os seguintes pacotes nao foram possiveis instalar: !failed_packages!
    for %%i in (%failed_packages%) do (
    echo - %%i
    )
)

:: Lista pacotes que foram instalados com sucesso
if defined successful_packages (
    echo.
    echo Os seguintes pacotes foram instalados com sucesso: !failed_packages!
    for %%i in (%successful_packages%) do (
    echo - %%i
    )
)

echo.

endlocal
pause
