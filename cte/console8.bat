@echo off
set c8_directory="C:\Certiport\Console"
set c8_config="%c8_directory%\Data\CTCConfig.enc"
set c8_backuploc="%temp%\Certiport_Backup"

:: echo Press any key to back up the current Console 8 Configuration and re-install:

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
if "%computername:~0,3%" == "409" set location=virgo
set location=unknown

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
	) else if %location%==unknown (
		echo %location% & set installcertiport=no && goto mainmenu 
		)


:mainmenu
cls
color a
echo.
echo  ::::::::   ::::::::  ::::    :::  ::::::::   ::::::::  :::        ::::::::::        ::::::::  
echo :+:    :+: :+:    :+: :+:+:   :+: :+:    :+: :+:    :+: :+:        :+:              :+:    :+: 
echo +:+        +:+    +:+ :+:+:+  +:+ +:+        +:+    +:+ +:+        +:+              +:+    +:+ 
echo +#+        +#+    +:+ +#+ +:+ +#+ +#++:++#++ +#+    +:+ +#+        +#++:++#          +#++:++#  
echo +#+        +#+    +#+ +#+  +#+#+#        +#+ +#+    +#+ +#+        +#+              +#+    +#+ 
echo #+#    #+# #+#    #+# #+#   #+#+# #+#    #+# #+#    #+# #+#        #+#              #+#    #+# 
echo  ########   ########  ###    ####  ########   ########  ########## ##########        ########  
echo.                                  
echo Choose an option: 
echo ---------------------------------------
echo 1: Backup current configuration
echo 2: Update current configuration
echo 3: Uninstall (Silent)
echo 4: Install (Silent)
echo 5: Restore configuration backup
echo 6: Exit
echo.
set /p menuchoice= Option: 
if %menuchoice%==1 (
	goto copyconfig
	) else if %menuchoice%==2 (
	goto checkconfig
	) else if %menuchoice%==3 (
	goto uninstall
	) else if %menuchoice%==4 (
	goto reinstall
	) else if %menuchoice%==5 (
	goto restoreconfig
	) else if %menuchoice%==6 (
	goto batchexit
	) else (echo This is not a valid entry. && pause && goto mainmenu)

:copyconfig
:: Copies config from working Console 8 directory to temp files
cls
echo f | xcopy %c8_config% %c8_backuploc%\CTCConfig.enc /Y
echo.
if %ERRORLEVEL% equ 0 (echo Config backed up successfully) else (echo Config not backed up.)
pause && goto mainmenu

:checkconfig
:: Replaces config with school's correct configuration file (autodesk/microsoft)
cls

if %installcertiport%==yes (
	set /p configtype= Is this an autodesk machine? Y/N:
	) else if %installcertiport%==no (
		echo Your school does not have a valid config. Please choose another option. & pause && goto mainmenu
	)
if %configtype%==y set configtype=autodesk
if %configtype%==n (
	set configtype=microsoft
) else (
	echo That is not a valid input. Please try again with a Y or an N. && goto checkconfig
)
pushd \\CBRCFS\staff_share$\Client Services\Software\Client Services Software\CTE Software\Certiport
copy /Y "\\CBRCFS\Staff_Share$\Client Services\Software\Scripts\afterimage\cte\certiport_configs\%location%\%configtype%\CTCConfig.enc" C:\Certiport\Console\Data\CTCConfig.enc
echo.
if %ERRORLEVEL% equ 0 (echo School's config has been successfully replaced. && pause && popd && goto mainmenu) else (echo School's config was not replaced. && pause && popd && goto mainmenu)

:uninstall
:: Uninstalls Console 8. Would prefer a better way to do this
cls
TASKKILL /F /IM CERTIPORTCONSOLE.EXE /IM CERTIPORTNOW.EXE
RMDIR /S /Q C:\CERTIPORT
REG DELETE "HKLM\SOFTWARE\WOW6432NODE\CERTIPORT" /F
REG DELETE "HKLM\SOFTWARE\WOW6432NODE\MICROSOFT\WINDOWS\CURRENTVERSION\UNINSTALL\CERTIPORTNOW" /F
REG DELETE "HKLM\SOFTWARE\WOW6432NODE\MICROSOFT\WINDOWS\CURRENTVERSION\UNINSTALL\CONSOLE 8" /F
SC DELETE CERTIPORTNOW
DEL "C:\USERS\PUBLIC\DESKTOP\CONSOLE *.LNK" /S
:: echo Console 8 has been successfully uninstalled. Press any key to re-install.
echo.
if %ERRORLEVEL% equ 0 (echo Console 8 has been successfully uninstalled. Press any key to return to the main menu.) else (echo Console 8 uninstallation was unsuccessful. Make sure you're running this as Administrator.)
pause && goto mainmenu

:reinstall
:: Reinstalls Console 8 from network drive
cls
echo Console 8 is installing...
pushd \\CBRCFS\staff_share$\Client Services\Software\Client Services Software\CTE Software\Certiport
"Console_Setup.exe" Path="C:\Certiport\console&lang=ENU&imode=Silent&iact=Install"
popd
:: echo Console 8 has been successfully re-installed. Press any key to restore the Config.
echo.
echo Console 8 has been successfully installed. Press any key to return to the main menu.
pause && goto mainmenu

:restoreconfig
:: Restores Console 8 config from temp files backup location
cls
C:
cd %c8_backuploc%
echo f | xcopy CTCConfig.enc %c8_config% /Y
:: if %ERRORLEVEL% equ 0 (del /F %c8_backuploc%\CTCConfig.enc && echo Config restored successfully) else (echo Config not restored.)
echo.
if %ERRORLEVEL% equ 0 (echo Config restored successfully) else (echo Config not restored.)
pause && goto mainmenu

:batchexit
:: Closes window
exit