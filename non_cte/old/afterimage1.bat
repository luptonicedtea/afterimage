@echo OFF

rem Model selection (leads to BIOS differences)
echo (0=none of the following) (1=645 g1) (2=745-755 G3) (3=745-755 G4)
set /p model= What is your device model?

rem Start and end word to process activation
:word
start winword.exe
timeout /T 20 /NOBREAK
taskkill /F /IM winword.exe
goto devmgr

rem Attempt at automatically installing drivers.
:hpmps
pushd \\CBRCFS\office$\stephen.lupton\DriveGuard\InstallFiles\Win10\
if %model%==1 pnputil -i -a .\accelerometer.inf
goto devmgr

rem Open Device Manager to confirm changes to drivers
:devmgr
echo You might want this: T:\Client Services\Software\Drivers\Machine Drivers\Laptop\HP
hdwwiz.cpl
pause
goto bios

rem Make SWSetup folder.
:bios
C:
md C:\SWSetup
if %model%==0 exit
if %model%==1 goto 645g1
if %model%==2 goto 745g3
if %model%==3 goto 745g4
 
rem Copy BIOS files and run installer based on %model%
:645g1
xcopy "\\CBRCFS\STAFF_SHARE$\Client Services\Software\Drivers\Machine Drivers\BIOS Updates\HP\Current\HP ProBook 645-655 G1\sp86995" C:\SWSetup\sp86995\
C:\SWSetup\sp86995\HPBIOSUPDREC64.exe
pause
exit

:745g3
xcopy "\\CBRCFS\STAFF_SHARE$\Client Services\Software\Drivers\Machine Drivers\BIOS Updates\HP\Current\HP EliteBook 745-755 G3\sp87012" C:\SWSetup\sp87012\
C:\SWSetup\sp87012\HPBIOSUPDREC64.exe
pause
exit

:745g4
xcopy "\\CBRCFS\STAFF_SHARE$\Client Services\Software\Drivers\Machine Drivers\BIOS Updates\HP\Current\HP EliteBook 745-755 G4\sp87005\" C:\SWSetup
C:\SWSetup\sp87005\HPBIOSUPDREC64.exe
pause
exit