@echo off

:: Grab the location, set as %location%. Only works for Middle and High School
if "%computername:~0,3%" == "326" set location=laney
if "%computername:~0,3%" == "327" set location=ashley
if "%computername:~0,3%" == "340" set location=bear
if "%computername:~0,3%" == "342" set location=hoggard
if "%computername:~0,3%" == "352" set location=newhanover
if "%computername:~0,3%" == "354" set location=jcroe
if "%computername:~0,3%" == "355" set location=mosley
if "%computername:~0,3%" == "394" set location=wec
if "%computername:~0,3%" == "395" set location=seatech
if "%computername:~0,3%" == "310" set location=murray
if "%computername:~0,3%" == "325" set location=trask
if "%computername:~0,3%" == "343" set location=hollyshelter
if "%computername:~0,3%" == "350" set location=noble
if "%computername:~0,3%" == "351" set location=myrtlegrove
if "%computername:~0,3%" == "364" set location=rolandgrise
if "%computername:~0,3%" == "392" set location=williston

:: Check to see if Certiport is necessary
if %location%==laney (
	set installcertiport=yes
	) else if %location%==ashley (
	set installcertiport=yes
	) else if %location%==bear (
	set installcertiport=yes
	) else if %location%==hoggard (
	set installcertiport=yes
	) else if %location%==newhanover (
	set installcertiport=yes
	) else if %location%==jcroe (
	set installcertiport=yes
	) else if %location%==mosley (
	set installcertiport=yes
	) else if %location%==wec (
	set installcertiport=yes
	) else if %location%==seatech (
	set installcertiport=yes
	) else (set installcertiport=no)

:: Grab the BIOS version and Model Number
FOR /F "tokens=2" %%a in ('wmic bios get smbiosbiosversion') do SET biosver=%%a
FOR /F "tokens=2*" %%a in ('wmic csproduct get name') do SET modelnum=%%a%%b

:: Exceptions for the BIOS version (some machines output it funny)
if "%modelnum%" == "CompaqPro 6305 SFF  " FOR /F "tokens=2" %%a in ('wmic bios get smbiosbiosversion') do SET biosver=%%a
if "%modelnum%" == "ProBook645 G1  " FOR /F "tokens=2*" %%a in ('wmic bios get smbiosbiosversion') do SET biosver=%%a%%b
if "%modelnum%" == "EliteBook745 G3  " FOR /F "tokens=3" %%a in ('wmic bios get smbiosbiosversion') do SET biosver=%%a
if "%modelnum%" == "EliteBook745 G4  " FOR /F "tokens=3" %%a in ('wmic bios get smbiosbiosversion') do SET biosver=%%a
if "%modelnum%" == "EliteBook755 G3  " FOR /F "tokens=3" %%a in ('wmic bios get smbiosbiosversion') do SET biosver=%%a
if "%modelnum%" == "EliteBook755 G4  " FOR /F "tokens=3" %%a in ('wmic bios get smbiosbiosversion') do SET biosver=%%a
if "%modelnum%" == "EliteDesk705 G2 MT  " FOR /F "tokens=3" %%a in ('wmic bios get smbiosbiosversion') do SET biosver=%%a
if "%modelnum%" == "EliteDesk705 G3 MT  " FOR /F "tokens=3" %%a in ('wmic bios get smbiosbiosversion') do SET biosver=%%a
if "%modelnum%" == "EliteDesk705 G3 SFF  " FOR /F "tokens=3" %%a in ('wmic bios get smbiosbiosversion') do SET biosver=%%a
if "%modelnum%" == "ProBook6475b  " FOR /F "tokens=3" %%a in ('wmic bios get smbiosbiosversion') do SET biosver=%%a

:: Close edge if running
taskkill /F /IM MicrosoftEdge.exe
taskkill /F /IM MicrosoftEdgeCP.exe
cls

:: Determine Console8 Configuration
echo Current school is %location%
echo Install Certiport is %installcertiport%

if "%installcertiport%"=="yes" (
	if exist "C:\Users\Public\Desktop\Console 8.lnk" (
		goto wordsearch
		) else if "%installcertiport%"=="no" (
			goto wordsearch
		)
	)

set /p config= Is this an autodesk machine? Y/N:

:: Experimenting with checking office activation
:wordsearch
:: The below directory is for users with a 64-bit operating system using 64-bit Office 
cls
set activated=" "
for /f "tokens=3 delims= " %%a in ('cscript "%ProgramFiles%\Microsoft Office\Office16\OSPP.VBS" /dstatus ^| find /i "License Status:"') do (
	set "licenseStatus=%%a"
	)

if /i "%licenseStatus%"=="---LICENSED---" (
	set activated="yes" & goto certiportcheck
    ) else (
	set activated="no" & start winword.exe & goto wordnotactivated
    )

:wordnotactivated
echo Waiting for activation to start...
timeout /t 5 /NOBREAK
tasklist /v|find "Microsoft Office Professional Plus 2016"
if %errorlevel% equ 0 (timeout /t 5 /NOBREAK && goto killword) else (goto wordnotactivated)

:killword
taskkill /F /IM winword.exe
goto certiportcheck

:certiportcheck
if %installcertiport%==no goto copyauto2
if exist "C:\Users\Public\Desktop\Console 8.lnk" goto copyauto2
if %installcertiport%==yes goto certiport

:certiport
if %config%==y set config=autodesk
if %config%==n (
	set config=microsoft
	) else (
	echo That is not a valid input. Please try again with a Y or an N. && goto certiport
	)
cls
echo Installing Console 8...
pushd \\CBRCFS\staff_share$\Client Services\Software\Client Services Software\CTE Software\Certiport
"Console_Setup.exe" Path="C:\Certiport\console&lang=ENU&imode=Silent&iact=Install"
copy /Y "\\CBRCFS\Staff_Share$\Client Services\Software\Scripts\afterimage\cte\certiport_configs\%location%\%config%\CTCConfig.enc" C:\Certiport\Console\Data\CTCConfig.enc
popd
goto copyauto2

:copyauto2
xcopy "\\CBRCFS\Staff_Share$\Client Services\Software\Scripts\afterimage\cte\CTE_afterimage_autoinstaller2.lnk" C:\Users\Public\Desktop\
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
if "%modelnum%" == "ProBook6475b  " (
    for /f "delims=: tokens=1*" %%A in ('systeminfo') do (
  for /f "tokens=*" %%S in ("%%B") do (
    if "%%A"=="BIOS Version" set "fullbios=%%S"
  )
)
ECHO.%fullbios%| FIND /I "68TTU">Nul && ( 
  goto 6475b68RTU
) || (
  goto 6475b68TTU
)
)

echo Your machine model doesn't match anything on record. Please manually upgrade your BIOS. Thanks!
pause
exit

:: Copy BIOS files and run installer based on %modelnum%, and determine whether they're up to date using %biosver%. If you want to add an updated bios installer,
:: you have to change the file path three times, copy the extracted files to the new path, and update the %biosver% that you want it to look for by checking
:: the tokens.

:6475b68TTU
FOR /F "tokens=1" %%a in ('wmic bios get smbiosbiosversion') do SET biosver=%%a
echo Your bios version is %biosver%. It should be F.69.
if "%biosver%"== "F.69" echo Your machine BIOS (%biosver%) is already up to date. & pause & exit
xcopy /E "\\CBRCFS\STAFF_SHARE$\Client Services\Software\Drivers\Machine Drivers\BIOS Updates\HP\Current\HP Probook 6475b\SP86984" C:\SWSetup\sp86984\
C:\SWSetup\sp86984\HpqFlash\sp86984_T.exe
pause
exit

:6475b68RTU
FOR /F "tokens=1" %%a in ('wmic bios get smbiosbiosversion') do SET biosver=%%a
echo Your bios version is %biosver%. It should be F.69.
if "%biosver%"== "F.69" echo Your machine BIOS (%biosver%) is already up to date. & pause & exit
xcopy /E "\\CBRCFS\STAFF_SHARE$\Client Services\Software\Drivers\Machine Drivers\BIOS Updates\HP\Current\HP Probook 6475b\SP86984" C:\SWSetup\sp86984\
C:\SWSetup\sp86984\HpqFlash\sp86984_R.exe
pause
exit

:6475b
echo Your bios version is %biosver%. It should be F.69.
if "%biosver%"== "F.69" echo Your machine BIOS (%biosver%) is already up to date. & pause & exit
xcopy /E "\\CBRCFS\STAFF_SHARE$\Client Services\Software\Drivers\Machine Drivers\BIOS Updates\HP\Current\HP Probook 6475b\SP86984" C:\SWSetup\sp86984\
C:\SWSetup\sp86984\**INSERT BIOS UPDATER HERE.EXE**
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