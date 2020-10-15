@echo off

for /f "tokens=1 delims=" %%# in ('qprocess^|find /i /c /n "firefox"') do (
    set count=%%#
)

taskkill /F /IM firefox.exe /T

echo Number of Mozilla Firefox processes removed: %count%
start "" "C:\Program Files\Mozilla Firefox\firefox.exe" -private
