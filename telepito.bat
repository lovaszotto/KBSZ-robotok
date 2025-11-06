@echo off
REM =====================================================
REM  KB01 KÖZBESZERZÉSI ÉRTESÍTŐ ROBOT - TELEPÍTŐ v1.0
REM  Robot Framework alapú automatizált közbeszerzési
REM  adatbázis keresés és adatlekérés
REM =====================================================
setlocal EnableDelayedExpansion

echo.
echo =====================================================
echo   KB01 KÖZBESZERZÉSI ÉRTESÍTŐ ROBOT TELEPÍTŐ v1.0
echo   
echo   Funkcionalitás:
echo   - Automatikus cookie kezelés
echo   - CPV értékek megadása és keresés
echo   - Dátum szűrés beállítása
echo   - Paginated táblázat adatok lekérése
echo   - Excel export (eredmeny.xlsx)
echo   - Selenium WebDriver integráció
echo   - Python 3.13 kompatibilitás
echo =====================================================
echo.

REM Telepítési könyvtár beállítása
REM KB01 projekt telepítése az aktuális könyvtárba
set "CURDIR=%CD%"
set "TARGET_DIR=%CURDIR%"
echo [INFO] Telepítési könyvtár: %TARGET_DIR%

REM Ha nem letezik a konyvtar, hozzuk letre
if not exist "%TARGET_DIR%" (
    echo [INFO] Telepitesi konyvtar letrehozasa: %TARGET_DIR%
    mkdir "%TARGET_DIR%"
)


echo.
echo Telepitesi cel: %TARGET_DIR%
echo.

REM Python 3.13 ellenőrzése
echo Python verzió ellenőrzése...
"C:\Users\oLovasz\AppData\Local\Programs\Python\Python313\python.exe" --version >nul 2>&1
if errorlevel 1 (
    echo HIBA: Python 3.13 nincs telepítve vagy nem elérhető!
    echo.
    echo Megoldások:
    echo 1. Telepítse a Python 3.13+ verzióit a python.org oldalról
    echo 2. Ellenőrizze a Python telepítési útvonalat
    echo 3. Használja a rendszer PATH-ban lévő python parancsot
    echo.
    REM Próba rendszer python-nal
    python --version >nul 2>&1
    if errorlevel 1 (
        echo Rendszer Python sem található!
        pause
        exit /b 1
    ) else (
        echo Rendszer Python használata...
        set "PYTHON_EXE=python"
    )
) else (
    echo Python 3.13 megtalálva!
    set "PYTHON_EXE=C:\Users\oLovasz\AppData\Local\Programs\Python\Python313\python.exe"
)

echo Python verzió:
"%PYTHON_EXE%" --version

REM Python verzió ellenőrzés
for /f "tokens=2" %%i in ('"%PYTHON_EXE%" --version 2^>^&1') do set PYTHON_VERSION=%%i
echo Talált Python verzió: %PYTHON_VERSION%

echo.
echo Python modulok ellenőrzése...
"%PYTHON_EXE%" -c "import sys; print('Python executable:', sys.executable)"
echo.

REM KB01 projekt fájlok már a helyükön vannak
echo KB01 projekt fájlok ellenőrzése...

REM Fontos fájlok ellenőrzése
if not exist "KB01_00*.robot" (
    echo HIBA: Fő robot fájl hiányzik!
    pause
    exit /b 1
)

if not exist "excel_library.py" (
    echo HIBA: Excel könyvtár hiányzik!
    pause
    exit /b 1
)

if not exist "requirements.txt" (
    echo HIBA: requirements.txt hiányzik!
    pause
    exit /b 1
)

echo Minden szükséges fájl megtalálható.
echo.

REM Csomagok telepítése a Python 3.13-ba
echo.
echo Csomagok telepítése requirements.txt alapján...
echo.

"%PYTHON_EXE%" -m pip install --upgrade pip

if errorlevel 1 (
    echo HIBA: pip frissítés sikertelen!
    pause
    exit /b 1
)

"%PYTHON_EXE%" -m pip install -r requirements.txt

if errorlevel 1 (
    echo HIBA: Csomagok telepítése sikertelen!
    echo.
    echo Próbálja egyenként:
    echo.
    "%PYTHON_EXE%" -m pip install robotframework==7.0
    "%PYTHON_EXE%" -m pip install robotframework-seleniumlibrary
    "%PYTHON_EXE%" -m pip install openpyxl
    "%PYTHON_EXE%" -m pip install pillow
    pause
    exit /b 1
)

echo.
echo Telepített csomagok ellenőrzése...
"%PYTHON_EXE%" -c "import robot; print('✅ Robot Framework:', robot.__version__)"
"%PYTHON_EXE%" -c "import SeleniumLibrary; print('✅ Selenium Library telepítve')"
"%PYTHON_EXE%" -c "import openpyxl; print('✅ OpenPyXL telepítve')"
echo.

echo.
echo =========================================
echo   KB01 TELEPÍTÉS SIKERES! ✅
echo =========================================
echo.
echo Telepített komponensek:
echo ✅ Robot Framework 7.0 (tesztvezérlési keretrendszer)
echo ✅ Selenium Library (WEB automatizálás)
echo ✅ OpenPyXL (Excel kezelés)
echo ✅ Pillow (képfeldolgozó)
echo ✅ KB01 Excel Library (egyedi Excel könyvtár)
echo ✅ Python 3.13 kompatibilitás
echo.
echo Projektfájlok:
echo - KB01_00 Közbeszerzési Értesítő.robot (fő teszt)
echo - KB01_01 CPV megadás.robot (CPV kezelés)
echo - KB01_02 Találatok lekérése.robot (adatlekérés)
echo - excel_library.py (Excel könyvtár)
echo - requirements.txt (függőségek)
echo - README.md (dokumentáció)
echo.
echo =========================================
echo   HASZNÁLAT:
echo =========================================
echo.
echo Robot futtatása:
echo   "%PYTHON_EXE%" -m robot "KB01_00 Közbeszerzési Értesítő.robot"
echo.
echo Eredmények:
echo - log.html (részletes log)
echo - report.html (összefoglaló)
echo - eredmeny.xlsx (lekért adatok)
echo.
echo Konfigurációs lehetőségek:
echo - CPV kódok: KB01_01 CPV megadás.robot
echo - Dátum szűrés: KB01_00 fájlban
echo - URL módosítása: KB01_00 fájlban
echo.
echo Dokumentáció: README.md
echo =========================================
echo.
echo Futtatási script létrehozása...

REM KB01_run.bat fájl létrehozása
echo @echo off > KB01_run.bat
echo REM ========================================= >> KB01_run.bat
echo REM  KB01 KÖZBESZERZÉSI ÉRTESÍTŐ ROBOT >> KB01_run.bat
echo REM ========================================= >> KB01_run.bat
echo echo. >> KB01_run.bat
echo echo ========================================= >> KB01_run.bat
echo echo   KB01 ROBOT INDÍTÁS >> KB01_run.bat
echo echo ========================================= >> KB01_run.bat
echo echo. >> KB01_run.bat
echo. >> KB01_run.bat
echo echo Robot Framework teszt indítása... >> KB01_run.bat
echo echo. >> KB01_run.bat
echo "%PYTHON_EXE%" -m robot KB01_00*.robot >> KB01_run.bat
echo. >> KB01_run.bat
echo echo. >> KB01_run.bat
echo echo ========================================= >> KB01_run.bat
echo echo   TESZT BEFEJEZVE >> KB01_run.bat
echo echo ========================================= >> KB01_run.bat
echo echo. >> KB01_run.bat
echo echo Eredmények: >> KB01_run.bat
echo echo - log.html (részletes log) >> KB01_run.bat  
echo echo - report.html (összefoglaló) >> KB01_run.bat
echo echo - eredmeny.xlsx (lekért adatok) >> KB01_run.bat
echo echo. >> KB01_run.bat
echo pause >> KB01_run.bat

echo.
echo KB01_run.bat fájl létrehozva a könnyű indításhoz!
echo.
echo Telepítés befejezve! ✅


