# KB01 - Közbeszerzési Értesítő Robot

Automatizált Robot Framework teszt a közbeszerzési adatbázis keresési funkcionalitásának tesztelésére.

## 🎯 Funkcionalitás

A robot a következő műveleteket hajtja végre:
1. **Sütik kezelése** - Cookie consent elfogadása
2. **CPV értékek megadása** - Közbeszerzési kódok beállítása (pl. 72230000)
3. **Dátum szűrés** - Dátumtól-dátumig szűrés beállítása
4. **Keresés indítása** - Szűrés gomb megnyomása
5. **Adatok lekérése** - Paginated táblázat adatok beolvasása Excel-be
6. **Bezárás** - Browser bezárása

## 🛠️ Telepítés

### Előfeltételek
- Python 3.13+
- Chrome böngésző

### Függőségek telepítése
```powershell
# Csomagok telepítése
C:\Users\oLovasz\AppData\Local\Programs\Python\Python313\python.exe -m pip install -r requirements.txt
```

## 🚀 Futtatás

```powershell
# Teszt futtatása
C:\Users\oLovasz\AppData\Local\Programs\Python\Python313\python.exe -m robot "KB01_00 Közbeszerzési Értesítő.robot"
```

## 📊 Kimenet

A teszt futtatása után a következő fájlok jönnek létre:
- `log.html` - Részletes teszt log
- `report.html` - Teszt eredmény összefoglaló
- `output.xml` - XML formátumú eredmények
- `eredmeny.xlsx` - Lekért táblázat adatok Excel formátumban

## 📁 Fájlok

### Fő fájlok
- `KB01_00 Közbeszerzési Értesítő.robot` - Fő teszt suite
- `KB01_01 CPV megadás.robot` - CPV kezelési keywords
- `KB01_02 Találatok lekérése.robot` - Adatlekérési és Excel írási keywords
- `excel_library.py` - Egyedi Excel könyvtár (RPA.Excel.Files helyett)

### Konfigurációs fájlok
- `requirements.txt` - Python függőségek
- `.gitignore` - Git kizárási szabályok

### Segéd fájlok
- `resources/keywords.robot` - További keyword definíciók

## 🔧 Technikai részletek

### Használt könyvtárak
- **SeleniumLibrary** - Web automatizálás
- **Collections** - Adatstruktúra kezelés
- **excel_library.SimpleExcel** - Egyedi Excel kezelés (openpyxl alapú)
- **OperatingSystem** - Rendszer műveletek
- **Dialogs** - Felhasználói input

### Kompatibilitás
- ✅ Python 3.13
- ✅ Robot Framework 7.0
- ✅ Chrome böngésző
- ✅ Windows 10/11

## 🐛 Hibaelhárítás

### Gyakori problémák
1. **Cookie gomb nem található** - A robot többféle cookie gomb variációt próbál
2. **Lapozás probléma** - JavaScript-tel való kattintás cookie consent esetén
3. **Excel írás hiba** - Egyedi könyvtár használata RPA framework helyett

### Debug módok
```powershell
# Részletes logging
robot --loglevel DEBUG "KB01_00 Közbeszerzési Értesítő.robot"

# Csak egy konkrét teszt futtatása
robot --test "Kezeld A Sütiket" "KB01_00 Közbeszerzési Értesítő.robot"
```

## 📝 Changelog

### v1.0.0 (2025-11-06)
- ✅ Teljes működőképesség Python 3.13-mal
- ✅ Egyedi Excel könyvtár implementáció
- ✅ Fejlett cookie kezelés
- ✅ Robust lapozási mechanizmus
- ✅ 6/6 teszt sikeres futtatása

## 🤝 Közreműködés

A projekt fejlesztése során:
1. Fork-old a repository-t
2. Hozz létre feature branch-et (`git checkout -b feature/amazing-feature`)
3. Commit-old a változásokat (`git commit -m 'Add some amazing feature'`)
4. Push-old a branch-et (`git push origin feature/amazing-feature`)
5. Nyiss Pull Request-et

## 📄 Licenc

Ez a projekt belső használatra készült a KBSZ számára.

---
**Státusz:** ✅ Működőképes | **Utolsó teszt:** 2025-11-06 | **Eredmény:** 6/6 ✅