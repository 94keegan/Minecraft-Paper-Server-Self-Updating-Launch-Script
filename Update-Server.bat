@echo off
title Paper Updater

echo [INFO] Updating Paper...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "Update-Paper.ps1"

if errorlevel 1 (
    echo.
    echo [ERROR] Update failed.
    pause
    exit /b 1
)

echo.
echo [INFO] Update process completed.
pause