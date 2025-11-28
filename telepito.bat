@echo off
chcp 65001 >nul
set PYTHONIOENCODING=utf-8

setlocal EnableDelayedExpansion

echo.
echo =====================================================
echo   CLA-SSISTANT TELEPITO v3.0
echo   gh release create v1.0.0 --title "v1.0.0" --notes "Első stabil verzió"
echo   Funkcionalitas:
echo   - GitHub repository letoltes es kezeles
echo   - Robot Framework automatizacio  
echo   - Git parancsok vezerles
echo   - Web interfesz tamogatas
echo   - Repository lista lekeres API-val
echo =====================================================
echo.


REM Telepítési könyvtár beállítása
set "CURDIR=%CD%"
echo [INFO] Telepítési könyvtár: %CURDIR%


REM Python meglétének és verziójának ellenőrzése
echo Python verzió ellenőrzése...
python --version >nul 2>&1
if errorlevel 1 (
    echo HIBA: Python nincs telepítve vagy nem elérhető a PATH-ban!
    echo.
    echo Telepítse a Python 3.8+ verziót, vagy adja hozzá a PATH-hoz!
    pause
    exit /b 1
)
echo Python verzió:
python --version
for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
echo Talált Python verzió: %PYTHON_VERSION%
echo.
python -c "import sys; print('Python executable:', sys.executable)"
echo.

REM Virtuális környezet létrehozása
echo Virtuális környezet létrehozása...
if not exist ".venv" (
    python -m venv .venv
    if errorlevel 1 (
        echo HIBA: Virtuális környezet létrehozása sikertelen!
        pause
        exit /b 1
    )
    echo Virtuális környezet sikeresen létrehozva.
) else (
    echo Virtuális környezet már létezik.
)
echo.


REM Csomagok telepítése a virtuális környezetbe
echo Szükséges Python csomagok telepítése...
.venv\Scripts\python.exe -m pip install --upgrade pip
.venv\Scripts\python.exe -m pip install robotframework
.venv\Scripts\python.exe -m pip install robotframework-seleniumlibrary
.venv\Scripts\python.exe -m pip install requests
.venv\Scripts\python.exe -m pip install flask
.venv\Scripts\python.exe -m pip install selenium
.venv\Scripts\python.exe -m pip install webdriver-manager

if errorlevel 1 (
    echo HIBA: Csomagok telepítése sikertelen!
    pause
    exit /b 1
)

echo.
echo =========================================
echo TELEPÍTÉS SIKERES!
echo.
echo Telepítési hely: %CURDIR%
echo.
exit 0


