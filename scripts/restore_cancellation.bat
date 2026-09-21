@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================
REM VanillaBase - Restore Cancellation v1
REM
REM Purpose:
REM   Undo the LAST successful restore by restoring the single
REM   PRE_RESTORE_*.zip archive created by restore.bat.
REM
REM Important behavior:
REM - server\ itself is never renamed or moved.
REM - The current post-restore state is NOT archived again.
REM - PRE_RESTORE is consumed only after a successful cancellation.
REM - If extraction fails, the PRE_RESTORE archive is kept.
REM
REM Expected structure:
REM   VanillaBase\
REM   |-- server\
REM   |-- backups\
REM   `-- scripts\
REM       `-- restore_cancellation.bat
REM ============================================================

set "PROJECT_DIR=%~dp0.."
set "SERVER_DIR=%PROJECT_DIR%\server"
set "BACKUP_DIR=%PROJECT_DIR%\backups"

if not exist "%BACKUP_DIR%\" (
    echo.
    echo [ERROR] Backups directory was not found:
    echo "%BACKUP_DIR%"
    echo.
    pause
    exit /b 1
)

if not exist "%SERVER_DIR%\" (
    echo.
    echo [ERROR] Server directory was not found:
    echo "%SERVER_DIR%"
    echo.
    pause
    exit /b 1
)

REM Find PRE_RESTORE archives.
set /a COUNT=0
for /f "delims=" %%F in ('dir /b /a-d /o-d "%BACKUP_DIR%\PRE_RESTORE_*.zip" 2^>nul') do (
    set /a COUNT+=1
    if !COUNT! EQU 1 set "PRE_RESTORE_FILE=%BACKUP_DIR%\%%F"
)

if !COUNT! EQU 0 (
    echo.
    echo ============================================================
    echo              VanillaBase Restore Cancellation
    echo ============================================================
    echo.
    echo [INFO] There is no PRE_RESTORE archive to restore.
    echo Nothing to cancel.
    echo.
    pause
    exit /b 0
)

if !COUNT! GTR 1 (
    echo.
    echo [WARNING] More than one PRE_RESTORE archive was found.
    echo The newest one will be used:
    echo "!PRE_RESTORE_FILE!"
    echo.
)

echo.
echo ============================================================
echo              VanillaBase Restore Cancellation
echo ============================================================
echo.
echo This will UNDO the last successful restore.
echo.
echo PRE_RESTORE:
echo "!PRE_RESTORE_FILE!"
echo.
echo WARNING:
echo The CURRENT post-restore server state will be replaced.
echo It will NOT be saved as another PRE_RESTORE.
echo The Minecraft server MUST be completely stopped.
echo.
choice /C YN /N /M "Is the Minecraft server completely stopped? [Y/N]: "
if errorlevel 2 (
    echo.
    echo Cancellation aborted.
    pause
    exit /b 0
)

echo.
choice /C YN /N /M "Undo the last restore now? [Y/N]: "
if errorlevel 2 (
    echo.
    echo Cancellation aborted.
    pause
    exit /b 0
)

echo.
echo [1/3] Clearing current server contents...

powershell -NoProfile -Command "$ErrorActionPreference='Stop'; Get-ChildItem -LiteralPath '%SERVER_DIR%' -Force | Remove-Item -Recurse -Force"

if errorlevel 1 (
    echo.
    echo [ERROR] Could not clear the current server contents.
    echo PRE_RESTORE was NOT deleted.
    echo.
    pause
    exit /b 1
)

echo [2/3] Restoring PRE_RESTORE...

powershell -NoProfile -Command "$ErrorActionPreference='Stop'; Expand-Archive -LiteralPath '!PRE_RESTORE_FILE!' -DestinationPath '%SERVER_DIR%' -Force"

if errorlevel 1 (
    echo.
    echo [CRITICAL] PRE_RESTORE extraction failed.
    echo DO NOT start the server yet.
    echo.
    echo The PRE_RESTORE archive was kept at:
    echo "!PRE_RESTORE_FILE!"
    echo.
    echo Run this script again after resolving the extraction problem,
    echo or restore the archive manually.
    echo.
    pause
    exit /b 2
)

echo [3/3] Verifying restored server structure...

if not exist "%SERVER_DIR%\server.properties" (
    echo.
    echo [WARNING] PRE_RESTORE was extracted, but server.properties
    echo was not found.
    echo.
    echo PRE_RESTORE will be KEPT for safety.
    echo Verify the server contents before starting VanillaBase.
    echo.
    pause
    exit /b 2
)

REM The undo point has served its purpose. Delete it only after a
REM successful extraction and basic verification.
del /q "!PRE_RESTORE_FILE!" >nul 2>&1

if exist "!PRE_RESTORE_FILE!" (
    echo.
    echo [WARNING] Restore cancellation succeeded, but PRE_RESTORE
    echo could not be deleted:
    echo "!PRE_RESTORE_FILE!"
    echo.
    echo You may remove it manually later.
    echo.
)

echo.
echo ============================================================
echo Last restore was cancelled successfully.
echo ============================================================
echo.
echo VanillaBase has returned to the state it had immediately
echo BEFORE the last restore.
echo.
echo The PRE_RESTORE undo point has been consumed.
echo.
echo You can now start VanillaBase and verify the server state.
echo.
pause
exit /b 0
