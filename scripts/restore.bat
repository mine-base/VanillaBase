@echo off
setlocal EnableExtensions EnableDelayedExpansion
REM VanillaBase Restore v2
REM Keeps server\ itself in place. Keeps only the newest PRE_RESTORE.

set "PROJECT_DIR=%~dp0.."
set "SERVER_DIR=%PROJECT_DIR%\server"
set "BACKUP_DIR=%PROJECT_DIR%\backups"

if not exist "%BACKUP_DIR%\" (
 echo [ERROR] Backups directory not found: "%BACKUP_DIR%"
 pause
 exit /b 1
)
if not exist "%SERVER_DIR%\" (
 echo [ERROR] Server directory not found: "%SERVER_DIR%"
 pause
 exit /b 1
)

echo.
echo ============================================================
echo                 VanillaBase Restore v2
echo ============================================================
echo.
echo WARNING: the CONTENTS of server\ will be replaced.
echo The Minecraft server MUST be completely stopped.
choice /C YN /N /M "Is the Minecraft server completely stopped? [Y/N]: "
if errorlevel 2 exit /b 0

set /a COUNT=0
echo.
echo Available backups:
echo ------------------------------------------------------------
for /f "delims=" %%F in ('dir /b /a-d /o-d "%BACKUP_DIR%\VanillaBase_*.zip" 2^>nul') do (
 set /a COUNT+=1
 set "BACKUP_!COUNT!=%%F"
 echo   !COUNT!. %%F
)
echo ------------------------------------------------------------
if !COUNT! EQU 0 (
 echo [ERROR] No VanillaBase_*.zip backups found.
 pause
 exit /b 1
)

set /p "SELECTION=Enter backup number to restore: "
if not defined SELECTION (
 echo [ERROR] No backup selected.
 pause
 exit /b 1
)
for /f "delims=0123456789" %%A in ("!SELECTION!") do (
 echo [ERROR] Invalid selection.
 pause
 exit /b 1
)
if !SELECTION! LSS 1 (
 echo [ERROR] Invalid selection.
 pause
 exit /b 1
)
if !SELECTION! GTR !COUNT! (
 echo [ERROR] Invalid selection.
 pause
 exit /b 1
)

for %%N in (!SELECTION!) do set "SELECTED_BACKUP=!BACKUP_%%N!"
set "BACKUP_FILE=%BACKUP_DIR%\!SELECTED_BACKUP!"

echo.
echo Selected: "!SELECTED_BACKUP!"
echo Current state will first be saved as PRE_RESTORE.
choice /C YN /N /M "Continue? [Y/N]: "
if errorlevel 2 exit /b 0

for /f "usebackq delims=" %%T in (`powershell -NoProfile -Command "Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'"`) do set "TIMESTAMP=%%T"
if not defined TIMESTAMP (
 echo [ERROR] Could not generate timestamp.
 pause
 exit /b 1
)
set "SAFETY=%BACKUP_DIR%\PRE_RESTORE_!TIMESTAMP!.zip"

echo.
echo [1/5] Creating new PRE_RESTORE safety backup...
powershell -NoProfile -Command "$ErrorActionPreference='Stop'; Compress-Archive -Path '%SERVER_DIR%\*' -DestinationPath '!SAFETY!' -CompressionLevel Optimal"
if errorlevel 1 (
 echo [ERROR] Could not create PRE_RESTORE. No server files were changed.
 if exist "!SAFETY!" del /q "!SAFETY!" >nul 2>&1
 pause
 exit /b 1
)

echo [2/5] Applying PRE_RESTORE retention...
REM Delete older PRE_RESTORE only AFTER the new one exists successfully.
for /f "delims=" %%F in ('dir /b /a-d "%BACKUP_DIR%\PRE_RESTORE_*.zip" 2^>nul') do (
 if /I not "%%F"=="PRE_RESTORE_!TIMESTAMP!.zip" (
  del /q "%BACKUP_DIR%\%%F" >nul 2>&1
  if exist "%BACKUP_DIR%\%%F" echo [WARNING] Could not remove old PRE_RESTORE: %%F
 )
)

echo [3/5] Clearing current server contents...
powershell -NoProfile -Command "$ErrorActionPreference='Stop'; Get-ChildItem -LiteralPath '%SERVER_DIR%' -Force | Remove-Item -Recurse -Force"
if errorlevel 1 (
 echo [ERROR] Could not clear server contents.
 echo PRE_RESTORE is safe at: "!SAFETY!"
 pause
 exit /b 1
)

echo [4/5] Extracting selected backup...
powershell -NoProfile -Command "$ErrorActionPreference='Stop'; Expand-Archive -LiteralPath '!BACKUP_FILE!' -DestinationPath '%SERVER_DIR%' -Force"
if errorlevel 1 (
 echo [ERROR] Extraction failed. Attempting automatic rollback...
 powershell -NoProfile -Command "$ErrorActionPreference='Stop'; Get-ChildItem -LiteralPath '%SERVER_DIR%' -Force | Remove-Item -Recurse -Force; Expand-Archive -LiteralPath '!SAFETY!' -DestinationPath '%SERVER_DIR%' -Force"
 if errorlevel 1 (
  echo [CRITICAL] Automatic rollback failed. DO NOT start the server.
  echo Recover manually from: "!SAFETY!"
  pause
  exit /b 2
 )
 echo Previous server state restored. Requested restore was NOT completed.
 pause
 exit /b 1
)

echo [5/5] Verifying restored server structure...
if not exist "%SERVER_DIR%\server.properties" (
 echo [WARNING] server.properties was not found after extraction.
 echo Keep PRE_RESTORE and verify the restored server before starting.
 echo PRE_RESTORE: "!SAFETY!"
 pause
 exit /b 2
)

echo.
echo ============================================================
echo Restore completed successfully.
echo ============================================================
echo Restored from: "!BACKUP_FILE!"
echo Undo point:    "!SAFETY!"
echo.
echo Only the newest successful PRE_RESTORE is retained.
echo You can now start VanillaBase and verify the restored state.
echo.
pause
exit /b 0
