:: Installer to be run post-image to ensure that BADWI has been completed. (Ask Doug Rogers)
:: If you don't need BADWI done, and just need the BIOS done, look in the bios_only folder.

@echo off

::Add runtime to log
echo %username%,%time%,%date% >> "\\CBRCFS\Staff_Share$\Client Services\Software\Scripts\afterimage\non_cte\run_log2.csv"

:: Grab the BIOS version and Model Number
FOR /F "tokens=2" %%a in ('^"\\CBRCFS\Staff_Share$\Client Services\Software\Scripts\afterimage\non_cte\wmicbios.bat^"') do SET biosver=%%a
FOR /F "tokens=2*" %%a in ('^"\\CBRCFS\Staff_Share$\Client Services\Software\Scripts\afterimage\non_cte\wmicmodel.bat^"') do SET modelnum=%%a%%b

:: Exceptions for the BIOS version (some machines output it funny)
if "%modelnum%" == "CompaqPro 6305 SFF  " FOR /F "tokens=2" %%a in ('^"\\CBRCFS\Staff_Share$\Client Services\Software\Scripts\afterimage\non_cte\wmicbios.bat^"') do SET biosver=%%a
if "%modelnum%" == "ProBook645 G1  " FOR /F "tokens=2*" %%a in ('^"\\CBRCFS\Staff_Share$\Client Services\Software\Scripts\afterimage\non_cte\wmicbios.bat^"') do SET biosver=%%a%%b
if "%modelnum%" == "EliteBook745 G3  " FOR /F "tokens=3" %%a in ('^"\\CBRCFS\Staff_Share$\Client Services\Software\Scripts\afterimage\non_cte\wmicbios.bat^"') do SET biosver=%%a
if "%modelnum%" == "EliteBook745 G4  " FOR /F "tokens=3" %%a in ('^"\\CBRCFS\Staff_Share$\Client Services\Software\Scripts\afterimage\non_cte\wmicbios.bat^"') do SET biosver=%%a
if "%modelnum%" == "EliteBook755 G3  " FOR /F "tokens=3" %%a in ('^"\\CBRCFS\Staff_Share$\Client Services\Software\Scripts\afterimage\non_cte\wmicbios.bat^"') do SET biosver=%%a
if "%modelnum%" == "EliteBook755 G4  " FOR /F "tokens=3" %%a in ('^"\\CBRCFS\Staff_Share$\Client Services\Software\Scripts\afterimage\non_cte\wmicbios.bat^"') do SET biosver=%%a
if "%modelnum%" == "EliteDesk705 G2 MT  " FOR /F "tokens=3" %%a in ('^"\\CBRCFS\Staff_Share$\Client Services\Software\Scripts\afterimage\non_cte\wmicbios.bat^"') do SET biosver=%%a
if "%modelnum%" == "EliteDesk705 G3 MT  " FOR /F "tokens=3" %%a in ('^"\\CBRCFS\Staff_Share$\Client Services\Software\Scripts\afterimage\non_cte\wmicbios.bat^"') do SET biosver=%%a
if "%modelnum%" == "EliteDesk705 G3 SFF  " FOR /F "tokens=3" %%a in ('^"\\CBRCFS\Staff_Share$\Client Services\Software\Scripts\afterimage\non_cte\wmicbios.bat^"') do SET biosver=%%a
if "%modelnum%" == "ProBook6475b  " FOR /F "tokens=3" %%a in ('^"\\CBRCFS\Staff_Share$\Client Services\Software\Scripts\afterimage\non_cte\wmicbios.bat^"') do SET biosver=%%a

:: Determine whether word is activated. If yes, don't start word. Go straight to device manager. If no, start word and wait for the activation window to open. 
:: Then, close word, and go to device manager.
:wordsearch
taskkill /f /im  OneDriveSetup.exe
set activated=" "
for /f "tokens=3 delims= " %%a in ('cscript "%ProgramFiles%\Microsoft Office\Office16\OSPP.VBS" /dstatus ^| find /i "License Status:"') do (
set "licenseStatus=%%a"
)

if /i "%licenseStatus%"=="---LICENSED---" (
        set activated="yes" & goto devmgr
    ) Else (
        set activated="no" & start winword.exe & goto wordnotactivated
    )
	
:: If word isn't activated, open word, wait for activator, go to kill word.
:wordnotactivated
echo Waiting for activation to start...
timeout /t 5 /NOBREAK
tasklist /v|find "Microsoft Office Professional Plus 2016"
if %errorlevel% equ 0 (timeout /t 5 /NOBREAK && goto killword) else (goto wordnotactivated)

:killword
taskkill /F /IM winword.exe
goto devmgr

:: Open Device Manager to confirm changes to drivers
:devmgr
echo \\CBRCFS\Staff_Share$\Client Services\Software\Drivers\Machine Drivers\Laptop\HP | clip
echo You might want this: T:\Client Services\Software\Drivers\Machine Drivers\Laptop\HP
hdwwiz.cpl
pause
goto copyauto2

:copyauto2
xcopy "\\CBRCFS\Staff_Share$\Client Services\Software\Scripts\afterimage\non_cte\afterimage_autoinstaller2.lnk" C:\Users\Public\Desktop\
goto bios

:: Make SWSetup folder.
:bios
C:
md C:\SWSetup

:: Determine which machine it is
echo %modelnum%
if "%modelnum%" == "EliteDesk705 G1 MT  " echo We found your model number! Press any key to begin BIOS update. & goto 705g1
if "%modelnum%" == "EliteDesk705 G1 SFF  " echo We found your model number! Press any key to begin BIOS update. & goto 705g1
if "%modelnum%" == "EliteDesk705 G2 MT  " echo We found your model number! Press any key to begin BIOS update. & goto 705g2
if "%modelnum%" == "EliteDesk705 G2 SFF  " echo We found your model number! Press any key to begin BIOS update. & goto 705g2
if "%modelnum%" == "EliteDesk705 G3 MT  " echo We found your model number! Press any key to begin BIOS update. & goto 705g3
if "%modelnum%" == "EliteDesk705 G3 SFF  " echo We found your model number! Press any key to begin BIOS update. & goto 705g3
if "%modelnum%" == "Compaq6005 Pro MT PC  " echo We found your model number! Press any key to begin BIOS update. & goto 6005
if "%modelnum%" == "CompaqPro 6305 MT  " echo We found your model number! Press any key to begin BIOS update. & goto 6305
if "%modelnum%" == "CompaqPro 6305 SFF  " echo We found your model number! Press any key to begin BIOS update. & goto 6305
if "%modelnum%" == "ProBook645 G1  " echo We found your model number! Press any key to begin BIOS update. & goto 645g1
if "%modelnum%" == "EliteBook745 G3  " echo We found your model number! Press any key to begin BIOS update. & goto 745g3
if "%modelnum%" == "EliteBook745 G4  " echo We found your model number! Press any key to begin BIOS update. & goto 745g4
if "%modelnum%" == "EliteBook755 G3  " echo We found your model number! Press any key to begin BIOS update. & goto 745g3
if "%modelnum%" == "EliteBook755 G4  " echo We found your model number! Press any key to begin BIOS update. & goto 745g4
if "%modelnum%" == "ProBook6475b  " echo We found your model number! Press any key to begin BIOS update. & goto 6475b

echo Your machine model doesn't match anything on record. Please manually upgrade your BIOS. Thanks!
pause
exit

:: Copy BIOS files and run installer based on %modelnum%, and determine whether they're up to date using %biosver%. If you want to add an updated bios installer,
:: you have to change the file path three times, copy the extracted files to the new path, and update the %biosver% that you want it to look for by checking
:: the tokens.

:6475b
echo Your bios version is %biosver%. It should be F.69.
if "%biosver%"== "F.69" echo Your machine BIOS (%biosver%) is already up to date. & pause & exit
xcopy /E "\\CBRCFS\STAFF_SHARE$\Client Services\Software\Drivers\Machine Drivers\BIOS Updates\HP\Current\HP Probook 6475b\SP86984" C:\SWSetup\sp86984\
C:\SWSetup\sp86984\hpqFlash64.exe
pause
exit

:645g1
echo Your bios version is %biosver%. It should be Ver.01.45.
if "%biosver%"== "Ver.01.45     " echo Your machine BIOS (%biosver%) is already up to date. & pause & exit
xcopy /E "\\CBRCFS\STAFF_SHARE$\Client Services\Software\Drivers\Machine Drivers\BIOS Updates\HP\Current\HP ProBook 645-655 G1\sp86995" C:\SWSetup\sp86995\
C:\SWSetup\sp86995\HPBIOSUPDREC64.exe
pause
exit

:745g3
echo Your bios version is %biosver%. It should be 01.23.
if "%biosver%"=="01.23" echo Your machine BIOS (%biosver%) is already up to date. & pause & exit
xcopy /E "\\CBRCFS\STAFF_SHARE$\Client Services\Software\Drivers\Machine Drivers\BIOS Updates\HP\Current\HP EliteBook 745-755 G3\sp87012" C:\SWSetup\sp87012\
C:\SWSetup\sp87012\HPBIOSUPDREC64.exe
pause
exit

:745g4
echo Your bios version is %biosver%. It should be 01.12.
if "%biosver%"=="01.12" echo Your machine BIOS (%biosver%) is already up to date. & pause & exit
xcopy /E "\\CBRCFS\STAFF_SHARE$\Client Services\Software\Drivers\Machine Drivers\BIOS Updates\HP\Current\HP EliteBook 745-755 G4\sp87005" C:\SWSetup\sp87005\
C:\SWSetup\sp87005\HPBIOSUPDREC64.exe
pause
exit

:705g1
echo Your bios version is %biosver%. It should be 02.30.
if "%biosver%"=="v02.30" echo Your machine BIOS is already up to date. & pause && exit
xcopy /E "\\CBRCFS\STAFF_SHARE$\Client Services\Software\Drivers\Machine Drivers\BIOS Updates\HP\Current\HP EliteDesk 705 G1\sp87070" C:\SWSetup\sp87070\
C:\SWSetup\sp87070\HPBIOSUPDREC\HPBIOSUPDREC64.exe
pause
exit

:705g2
echo Your bios version is %biosver%. It should be 02.22.
if "%biosver%"=="02.22" echo Your machine BIOS is already up to date. & pause && exit
xcopy /E "\\CBRCFS\STAFF_SHARE$\Client Services\Software\Drivers\Machine Drivers\BIOS Updates\HP\Current\HP EliteDesk 705 G2\sp87009" C:\SWSetup\sp87009\
C:\SWSetup\sp87009\HPBIOSUPDREC\HPBIOSUPDREC64.exe
pause
exit

:705g3
echo Your bios version is %biosver%. It should be 02.13.
if "%biosver%"=="02.13" echo Your machine BIOS is already up to date. & pause && exit
xcopy /E "\\CBRCFS\STAFF_SHARE$\Client Services\Software\Drivers\Machine Drivers\BIOS Updates\HP\Current\HP EliteDesk 705 G3\sp87004" C:\SWSetup\sp87004\
C:\SWSetup\sp87004\HPBIOSUPDREC\HPBIOSUPDREC64.exe
pause
exit

:6005
echo Your bios version is %biosver%. It should be v01.17.
if "%biosver%"=="v01.17" echo Your machine BIOS is already up to date. & pause && exit
xcopy /E "\\CBRCFS\STAFF_SHARE$\Client Services\Software\Drivers\Machine Drivers\BIOS Updates\HP\Current\HP Compaq 6005 Pro\sp57308" C:\SWSetup\sp57308\
C:\SWSetup\sp57308\HPQFlash\HpqFlash.exe
pause
exit

:6305
echo Your bios version is %biosver%. It should be v02.77.
if "%biosver%"=="v02.77" echo Your machine BIOS is already up to date. & pause && exit
xcopy /E "\\CBRCFS\STAFF_SHARE$\Client Services\Software\Drivers\Machine Drivers\BIOS Updates\HP\Current\HP Compaq Pro 6305\sp87071" C:\SWSetup\sp87071\
C:\SWSetup\sp87071\HPQFlash\HpqFlash.exe
pause
exit