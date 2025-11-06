@echo off 
REM ========================================= 
REM  KB01 KÖZBESZERZÉSI ÉRTESÍTŐ ROBOT 
REM ========================================= 
echo. 
echo ========================================= 
echo   KB01 ROBOT INDÍTÁS 
echo ========================================= 
echo. 
 
echo Robot Framework teszt indítása... 
echo. 
"C:\Users\oLovasz\AppData\Local\Programs\Python\Python313\python.exe" -m robot KB01_00*.robot 
 
echo. 
echo ========================================= 
echo   TESZT BEFEJEZVE 
echo ========================================= 
echo. 
echo Eredmények: 
echo - log.html (részletes log)   
echo - report.html (összefoglaló) 
echo - eredmeny.xlsx (lekért adatok) 
echo. 
pause 
