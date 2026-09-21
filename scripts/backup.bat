@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================
REM VanillaBase - Backup script v2
REM
REM Expected structure:
REM   VanillaBase\
REM   |-- server\
REM   |-- backups\
REM   `-- scripts\
REM       `-- backup.bat
REM
REM Retention:
REM   Keep at most 3 regular VanillaBase_*.zip backups.
REM   PRE_RESTORE_*.zip archives are NOT affected.
REM
REM IMPORTANT:
REM   This manual v2 backup is still intended to run while the
REM   Minecraft server is completely STOPPED.
REM ============================================================

set "PROJECT_DIR=%~dp0.."
set "SERVER_DIR=%PROJECT_DIR%\server"
set "BACKUP_DIR=%PROJECT_DIR%\backups"
set "MAX_BACKUPS=3"

if not exist "%SERVER_DIR%\" (
    echo.
    echo [ERROR] Server directory was not found:
    echo "%SERVER_DIR%"
    echo.
    pause
    exit /b 1
)

if not exist "%BACKUP_DIR%\" (
    mkdir "%BACKUP_DIR%"
    if errorlevel 1 (
        echo.
        echo [ERROR] Could not create backups directory:
        echo "%BACKUP_DIR%"
        echo.
        pause
        exit /b 1
    )
)

echo.
echo ============================================================
echo                  VanillaBase Backup v2
echo ============================================================
echo.
echo This manual backup should be created with the server STOPPED.
echo Regular backup retention: maximum %MAX_BACKUPS% archives.
echo.
choice /C YN /N /M "Is the Minecraft server completely stopped? [Y/N]: "
if errorlevel 2 (
    echo.
    echo Backup cancelled.
    pause
    exit /b 0
)

for /f "usebackq delims=" %%T in (`powershell -NoProfile -Command "Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'"`) do set "TIMESTAMP=%%T"

if not defined TIMESTAMP (
    echo.
    echo [ERROR] Could not generate backup timestamp.
    echo.
    pause
    exit /b 1
)

set "BACKUP_FILE=%BACKUP_DIR%\VanillaBase_!TIMESTAMP!.zip"

echo.
echo [1/2] Creating backup...
echo Source:      "%SERVER_DIR%"
echo Destination: "!BACKUP_FILE!"
echo.

powershell -NoProfile -Command "$ErrorActionPreference='Stop'; Compress-Archive -Path '%SERVER_DIR%\*' -DestinationPath '!BACKUP_FILE!' -CompressionLevel Optimal"

if errorlevel 1 (
    echo.
    echo [ERROR] Backup creation failed.
    echo Existing backups were NOT removed.
    echo.
    if exist "!BACKUP_FILE!" del /q "!BACKUP_FILE!" >nul 2>&1
    pause
    exit /b 1
)

echo [2/2] Applying backup retention...

REM VanillaBase timestamps use yyyy-MM-dd_HH-mm-ss, so filename order
REM is chronological. /o-d lists newest first. Everything after the
REM first MAX_BACKUPS regular backups is deleted.
set /a INDEX=0
for /f "delims=" %%F in ('dir /b /a-d /o-d "%BACKUP_DIR%\VanillaBase_*.zip" 2^>nul') do (
    set /a INDEX+=1
    if !INDEX! GTR %MAX_BACKUPS% (
        echo Deleting old backup: %%F
        del /q "%BACKUP_DIR%\%%F" >nul 2>&1
        if exist "%BACKUP_DIR%\%%F" (
            echo [WARNING] Could not delete old backup: %%F
        )
    )
)

echo.
echo ============================================================
echo Backup completed successfully.
echo ============================================================
echo.
echo Created:
echo "!BACKUP_FILE!"
echo.
echo Regular backups kept: maximum %MAX_BACKUPS%
echo PRE_RESTORE archives were not affected.
echo.
pause
exit /b 0
