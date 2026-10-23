@echo off
setlocal EnableDelayedExpansion

REM ==========================================
REM Configuration
REM ==========================================

set MIN_RAM=4096M
set MAX_RAM=4096M

REM ==========================================
REM Update Paper
REM ==========================================

echo [INFO] Updating Paper...
powershell -NoProfile -ExecutionPolicy Bypass -File "Update-Paper.ps1"

if errorlevel 1 (
    echo [ERROR] Update failed.
    pause
    exit /b 1
)

echo.

REM ==========================================
REM Find newest Paper JAR
REM ==========================================

for /f "delims=" %%i in ('dir /b /o-d paper-*.jar') do (
    set JAR=%%i
    goto run
)

echo [ERROR] No Paper JAR found.
pause
exit /b 1

:run
echo [INFO] Starting !JAR!

java -Xms%MIN_RAM% -Xmx%MAX_RAM% -jar "!JAR!" --nogui

echo.
echo [INFO] Server stopped.
pause