@echo off
setlocal EnableDelayedExpansion

REM ==========================================
REM Update Paper before starting the server
REM ==========================================

echo Updating Paper...
powershell -NoProfile -ExecutionPolicy Bypass -File "Update-Paper.ps1"

echo.

REM ==========================================
REM Find newest downloaded Paper JAR
REM ==========================================

for /f "delims=" %%i in ('dir /b /o-d paper-*.jar') do (
    set JAR=%%i
    goto run
)

echo No Paper JAR found.
pause
exit /b 1

:run
echo Starting !JAR!

java -Xms4096M -Xmx4096M -jar "!JAR!" --nogui

echo.
echo Server stopped.
pause