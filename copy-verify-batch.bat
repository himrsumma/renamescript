@echo off
setlocal enabledelayedexpansion

:: Stel de doelmap in (pas dit aan naar wens)
set "DEST_PATH=C:\exam"

:: Maak logbestand met datum en tijd
set "TIMESTAMP=%date:~-4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
set "TIMESTAMP=%TIMESTAMP: =0%"
set "LOGFILE=file_copy_%TIMESTAMP%.log"

:: Toon start informatie
echo ===============================================
echo Bestand Kopieer Script met Verificatie
echo ===============================================
echo.
echo Bronmap: %~dp0
echo Doelmap: %DEST_PATH%
echo Logbestand: %LOGFILE%
echo.
echo Dit script zal:
echo 1. Alle bestanden kopieren vanaf de huidige locatie
echo 2. De kopie controleren met een checksum
echo 3. Resultaten opslaan in een logbestand
echo.
pause
echo.

:: Maak doelmap aan als deze niet bestaat
if not exist "%DEST_PATH%" (
    mkdir "%DEST_PATH%"
    echo [%date% %time%] Doelmap aangemaakt: %DEST_PATH% >> %LOGFILE%
)

:: Initialiseer tellers
set /a "total=0"
set /a "success=0"
set /a "failed=0"

:: Start het kopieren
echo [%date% %time%] Start kopieer proces... >> %LOGFILE%
echo Kopieren en verifieren van bestanden...
echo Dit kan even duren, afhankelijk van de hoeveelheid data.
echo.

:: Loop door alle bestanden
for /r "%~dp0" %%F in (*) do (
    set /a "total+=1"
    set "sourcefile=%%F"
    set "destfile=%DEST_PATH%\%%~pnxF"
    
    :: Maak doelmap structuur
    if not exist "!DEST_PATH!%%~pF" mkdir "!DEST_PATH!%%~pF"
    
    echo Kopieren: %%~nxF
    echo [%date% %time%] Kopieren: !sourcefile! >> %LOGFILE%
    
    :: Kopieer bestand
    copy "!sourcefile!" "!destfile!" /B /Y > nul
    
    :: Verifieer kopie met FC (File Compare)
    fc /b "!sourcefile!" "!destfile!" > nul
    if !errorlevel! == 0 (
        echo [%date% %time%] Verificatie succesvol: %%~nxF >> %LOGFILE%
        set /a "success+=1"
    ) else (
        echo [%date% %time%] FOUT: Verificatie mislukt voor: %%~nxF >> %LOGFILE%
        echo WAARSCHUWING: Verificatie mislukt voor: %%~nxF
        set /a "failed+=1"
    )
)

:: Toon resultaten
echo.
echo ===============================================
echo Kopieer Resultaten:
echo ===============================================
echo Totaal aantal bestanden: %total%
echo Succesvol gekopieerd: %success%
echo Mislukt: %failed%
echo.
echo Zie %LOGFILE% voor details
echo.

:: Schrijf resultaten naar log
echo [%date% %time%] Kopieer proces voltooid >> %LOGFILE%
echo [%date% %time%] Totaal aantal bestanden: %total% >> %LOGFILE%
echo [%date% %time%] Succesvol gekopieerd: %success% >> %LOGFILE%
echo [%date% %time%] Mislukt: %failed% >> %LOGFILE%

pause
