@echo off
set loopcount=60

rem :lock
rem rundll32.exe user32.dll, LockWorkStation
rem goto updating

del /f "C:\Users\Public\Desktop\CTE_afterimage_autoinstaller2.lnk"

:updating
@echo off
WMIC /namespace:\\root\ccm path sms_client CALL TriggerSchedule "{00000000-0000-0000-0000-000000000022}" /NOINTERACTIVE
cls
echo I'm going to look for icons now. I'll turn off when I find them all. =)

:shutdowncheck
if NOT exist "C:\Users\Public\Desktop\ServerApps.lnk" goto timer
if NOT exist "C:\Users\Public\Desktop\Software Center.lnk" goto timer
if NOT exist "C:\Users\Public\Desktop\Student Web Apps.lnk" goto timer
if NOT exist "C:\Users\Public\Desktop\Teacher Web Apps.lnk" goto timer
if NOT exist "C:\Users\Public\Desktop\NCEdCloud.lnk" goto timer
goto turnoff

:timer
timeout /T 60 > nul
set /a loopcount=loopcount-1
if %loopcount%==0 goto turnoff
goto shutdowncheck

:turnoff
shutdown -s -t 20 -c "The computer will shut down in twenty seconds."