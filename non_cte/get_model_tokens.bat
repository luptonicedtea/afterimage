:: For determining %modelnum% to be used to determine %biosver%

@echo off
FOR /F "tokens=2* " %%a in ('wmicmodel.bat') do set modelnum=%%a%%b
echo "%modelnum%" > C:\Users\%username%\Desktop\modelnum.txt
pause