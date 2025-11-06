@echo off
REM =====================================================
REM  KB01 KOZBESZERZESI ERTESITO ROBOT - TELEPITO v1.0
REM  Robot Framework alapu automatizalt kozbeszerzesi
REM  adatbazis kereses es adatlekeres
REM =====================================================
chcp 65001 >nul 2>&1
setlocal EnableDelayedExpansion

echo.
echo =====================================================
echo   KB01 KOZBESZERZESI ERTESITO ROBOT TELEPITO v1.0
echo   
echo   Funkcionalitas:
echo   - Automatikus cookie kezeles
echo   - CPV ertekek megadasa es kereses
echo   - Datum szures beallitasa
echo   - Paginated tablazat adatok lekerése
echo   - Excel export (eredmeny.xlsx)
echo   - Selenium WebDriver integracio
echo   - Python 3.13 kompatibilitas
echo =====================================================
echo.

REM Telepitesi konyvtar beallitasa
REM KB01 projekt telepitese az aktualis konyvtarba
set "CURDIR=%CD%"
set "TARGET_DIR=%CURDIR%"
set "TARGET_DIR=%CURDIR:DownloadedRobots=InstalledRobots%"
set "TARGET_DIR=%CURDIR:SandboxRobots=InstalledRobots%"
echo [INFO] Telepitesi konyvtar: %TARGET_DIR%

REM Ha nem letezik a konyvtar, hozzuk letre
if not exist "%TARGET_DIR%" (
    echo [INFO] Telepitesi konyvtar letrehozasa: %TARGET_DIR%
    mkdir "%TARGET_DIR%"
)


echo.
echo Telepitesi cel: %TARGET_DIR%
echo.

REM Fajlok masolasa a cel konyvtarba
if not "%TARGET_DIR%" == "%CURDIR%" (
    echo.
    echo Fajlok masolasa a telepitesi konyvtarba...
    
    REM Robot fajlok masolasa
    copy "*.robot" "%TARGET_DIR%\" >nul
    if errorlevel 1 (
        echo HIBA: Robot fajlok masolasa sikertelen!
        pause
        exit /b 1
    )
    
    REM Python konyvtarak masolasa
    copy "*.py" "%TARGET_DIR%\" >nul
    if errorlevel 1 (
        echo HIBA: Python fajlok masolasa sikertelen!
        pause
        exit /b 1
    )
    
    REM Konfiguracios fajlok masolasa
    copy "requirements.txt" "%TARGET_DIR%\" >nul 2>&1
    copy "README.md" "%TARGET_DIR%\" >nul 2>&1
    copy ".gitignore" "%TARGET_DIR%\" >nul 2>&1
    
    REM Resources mappa masolasa
    if exist "resources" (
        echo Resources mappa masolasa...
        xcopy "resources" "%TARGET_DIR%\resources" /E /I /Y >nul
    )
    
    echo Fajlok sikeresen masolva.
    echo.
    
    REM Atlepunk a cel konyvtarba a tovabbiakhoz
    cd /d "%TARGET_DIR%"
)

REM Python 3.13 ellenorzese
echo Python verzio ellenorzese...
"C:\Users\oLovasz\AppData\Local\Programs\Python\Python313\python.exe" --version >nul 2>&1
if errorlevel 1 (
    echo HIBA: Python 3.13 nincs telepitve vagy nem elerheto!
    echo.
    echo Megoldasok:
    echo 1. Telepitse a Python 3.13+ verzioit a python.org oldalrol
    echo 2. Ellenorizze a Python telepitesi utvonalat
    echo 3. Hasznaja a rendszer PATH-ban levo python parancsot
    echo.
    REM Proba rendszer python-nal
    python --version >nul 2>&1
    if errorlevel 1 (
        echo Rendszer Python sem talalhato!
        pause
        exit /b 1
    ) else (
        echo Rendszer Python hasznalata...
        set "PYTHON_EXE=python"
    )
) else (
    echo Python 3.13 megtalava!
    set "PYTHON_EXE=C:\Users\oLovasz\AppData\Local\Programs\Python\Python313\python.exe"
)

echo Python verzio:
"%PYTHON_EXE%" --version

REM Python verzio ellenorzes
for /f "tokens=2" %%i in ('"%PYTHON_EXE%" --version 2^>^&1') do set PYTHON_VERSION=%%i
echo Talalt Python verzio: %PYTHON_VERSION%

echo.
echo Python modulok ellenorzese...
"%PYTHON_EXE%" -c "import sys; print('Python executable:', sys.executable)"
echo.

REM KB01 projekt fajlok mar a helyukon vannak
echo KB01 projekt fajlok ellenorzese...

REM Fontos fajlok ellenorzese
if not exist "KB01_00*.robot" (
    echo HIBA: Fo robot fajl hianyzik!
    pause
    exit /b 1
)

if not exist "excel_library.py" (
    echo HIBA: Excel konyvtar hianyzik!
    pause
    exit /b 1
)

if not exist "requirements.txt" (
    echo HIBA: requirements.txt hianyzik!
    pause
    exit /b 1
)

echo Minden szukseges fajl megtalalhato.
echo.

REM Csomagok telepitese a Python 3.13-ba
echo.
echo Csomagok telepitese requirements.txt alapjan...
echo.

"%PYTHON_EXE%" -m pip install --upgrade pip

if errorlevel 1 (
    echo HIBA: pip frissites sikertelen!
    pause
    exit /b 1
)

"%PYTHON_EXE%" -m pip install -r requirements.txt

if errorlevel 1 (
    echo HIBA: Csomagok telepitese sikertelen!
    echo.
    echo Probalja egyenkent:
    echo.
    "%PYTHON_EXE%" -m pip install robotframework==7.0
    "%PYTHON_EXE%" -m pip install robotframework-seleniumlibrary
    "%PYTHON_EXE%" -m pip install openpyxl
    "%PYTHON_EXE%" -m pip install pillow
    pause
    exit /b 1
)

echo.
echo Telepitett csomagok ellenorzese...
"%PYTHON_EXE%" -c "import robot; print('[OK] Robot Framework:', robot.__version__)"
"%PYTHON_EXE%" -c "import SeleniumLibrary; print('[OK] Selenium Library telepitve')"
"%PYTHON_EXE%" -c "import openpyxl; print('[OK] OpenPyXL telepitve')"
echo.

echo.
echo =========================================
echo   KB01 TELEPITES SIKERES! [OK]
echo =========================================
echo.
echo Telepitett komponensek:
echo [OK] Robot Framework 7.0 (tesztvezerlesi keretrendszer)
echo [OK] Selenium Library (WEB automatizalas)
echo [OK] OpenPyXL (Excel kezeles)
echo [OK] Pillow (kepfeldolgozo)
echo [OK] KB01 Excel Library (egyedi Excel konyvtar)
echo [OK] Python 3.13 kompatibilitas
echo.
echo Projektfajlok:
echo - KB01_00 Kozbeszerzesi Ertesito.robot (fo teszt)
echo - KB01_01 CPV megadas.robot (CPV kezeles)
echo - KB01_02 Talalatok lekerése.robot (adatlekeres)
echo - excel_library.py (Excel konyvtar)
echo - requirements.txt (fuggoségek)
echo - README.md (dokumentacio)
echo.
echo =========================================
echo   HASZNALAT:
echo =========================================
echo.
echo Robot futtatasa:
echo   "%PYTHON_EXE%" -m robot KB01_00*.robot
echo.
echo Eredmenyek:
echo - log.html (reszletes log)
echo - report.html (osszefoglalo)
echo - eredmeny.xlsx (lekert adatok)
echo.
echo Konfiguracios lehetősegek:
echo - CPV kodok: KB01_01 CPV megadas.robot
echo - Datum szures: KB01_00 fajlban
echo - URL modositasa: KB01_00 fajlban
echo.
echo Dokumentacio: README.md
echo =========================================
echo.
echo Futtatasi script letrehozasa...

REM start.bat fajl letrehozasa
echo @echo off > start.bat
echo chcp 65001 ^>nul 2^>^&1 >> start.bat
echo REM ========================================= >> start.bat
echo REM  KB01 KOZBESZERZESI ERTESITO ROBOT >> start.bat
echo REM ========================================= >> start.bat
echo echo. >> start.bat
echo echo ========================================= >> start.bat
echo echo   KB01 ROBOT INDITAS >> start.bat
echo echo ========================================= >> start.bat
echo echo. >> start.bat
echo. >> start.bat
echo echo Robot Framework teszt inditasa... >> start.bat
echo echo. >> start.bat
echo "%PYTHON_EXE%" -m robot KB01_00*.robot >> start.bat
echo. >> start.bat
echo echo. >> start.bat
echo echo ========================================= >> start.bat
echo echo   TESZT BEFEJEZVE >> start.bat
echo echo ========================================= >> start.bat
echo echo. >> start.bat
echo echo Eredmenyek: >> start.bat
echo echo - log.html (reszletes log) >> start.bat  
echo echo - report.html (osszefoglalo) >> start.bat
echo echo - eredmeny.xlsx (lekert adatok) >> start.bat
echo echo. >> start.bat


echo.
echo start.bat fajl letrehozva a konnyu inditashoz!
echo.
echo Telepites befejezve! [OK]
echo.
echo =========================================
echo   ROBOT AUTOMATIKUS INDITAS
echo =========================================
echo.
echo Atvaltas a telepitett projektbe es robot inditasa...
echo.

REM Atvaltas a telepitett projekt konyvtaraba
cd /d "%TARGET_DIR%"

REM start.bat inditasa
if exist "start.bat" (
    echo Robot inditasa a telepitett konyvtarbol: %TARGET_DIR%
    echo.
    call start.bat
) else (
    echo HIBA: start.bat nem talalhato a telepitett konyvtarban!
    echo Konyvtar: %TARGET_DIR%
    echo.
    echo Manualisan indithatja:
    echo cd /d "%TARGET_DIR%"
    echo start.bat
    pause
)

echo.
echo Telepites es robot futtas befejezve!
exit /b 0


