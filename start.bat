@echo off
chcp 65001 >nul
set PYTHONIOENCODING=utf-8
REM ========================================= 
REM  KB01 KOZBESZERZESI ERTESITO ROBOT 
REM ========================================= 
echo. 
echo ========================================= 
echo   KB01 ROBOT INDITAS 
echo ========================================= 
echo. 
:: Aktualis konyvtar kiirasa
echo Aktualis munkakonyvtar: %CD%
echo.

:: Virtualis kornyezet ellenorzese
echo [1/3] Virtualis kornyezet ellenorzese...

if not exist ".venv\Scripts\python.exe" (
    echo HIBA: Virtualis kornyezet nem talalhato!
    echo Futtassa eloszor a telepito.bat fajlt!
    pause
    exit /b 1
)
.venv\Scripts\python.exe --version
if %errorlevel% neq 0 (
    echo HIBA: Python nem indult el a virtualis kornyezetbol!
    pause
    exit /b 2
) 
echo Robot Framework teszt inditasa... 
echo. 
:: Use the project's virtualenv python to run Robot so the correct interpreter and packages are used
:: Ensure ChromeDriver matching installed Chrome is available (requires webdriver-manager in venv)
echo [2/3] Chromedriver ellenorzese (webdriver-manager)...
.venv\Scripts\python.exe -c "from webdriver_manager.chrome import ChromeDriverManager; print('chromedriver:', ChromeDriverManager().install())"
if %errorlevel% neq 0 (
    echo WARN: Chromedriver letoltese sikertelen vagy webdriver-manager nincs telepitve.
    echo Telepites javasolt: .venv\Scripts\python.exe -m pip install webdriver-manager
)

echo [3/3] Robot futtatasa...
echo.
.venv\Scripts\python.exe -m robot main.robot
set RC=%ERRORLEVEL%
echo Robot visszateresi kod: %RC%

:: Wait 15 seconds and close any open Excel processes (so Excel windows opened by the run are closed)
echo Excel bezarasa 15 masodperc mulva...
timeout /t 15 /nobreak >nul
echo Excel bezarasa...
taskkill /IM excel.exe /F >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Excel sikeresen bezarva.
) else (
    echo Nincs futo Excel folyamat vagy nem sikerult befejezni.
)

if %RC% neq 0 (
    echo HIBA: Robot futtatas sikertelen. Nyomjon meg egy billentyut a folytatashoz...
    pause
)

exit /b %RC%
 
echo. 
echo ========================================= 
echo   TESZT BEFEJEZVE 
echo ========================================= 

exit 0
