@echo off 
chcp 65001 >nul 2>&1 
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
python -m robot KB01_00*.robot 
 
echo. 
echo ========================================= 
echo   TESZT BEFEJEZVE 
echo ========================================= 
echo. 
echo Eredmenyek: 
echo - log.html (reszletes log)   
echo - report.html (osszefoglalo) 
echo - eredmeny.xlsx (lekert adatok) 
echo. 
exit 0
