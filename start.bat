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
python -m robot main.robot 
 
echo. 
echo ========================================= 
echo   TESZT BEFEJEZVE 
echo ========================================= 

exit 0
