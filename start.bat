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
pause 
