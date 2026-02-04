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
set "RF_TMP_OUTPUT=%TEMP%\robot_output_%RANDOM%.xml"
echo Ideiglenes Robot output: %RF_TMP_OUTPUT%
.venv\Scripts\python.exe -m robot --output "%RF_TMP_OUTPUT%" --log log.html --report report.html main.robot
set RC=%ERRORLEVEL%
echo Robot visszateresi kod: %RC%

REM Ne maradjon semmilyen output XML a futas utan
del /q "%RF_TMP_OUTPUT%" >nul 2>&1





if %RC% neq 0 (
    echo HIBA: Robot futtatas sikertelen.
    
)

exit /b %RC%
 
echo. 
echo ========================================= 
echo   TESZT BEFEJEZVE 
echo ========================================= 

exit 0
