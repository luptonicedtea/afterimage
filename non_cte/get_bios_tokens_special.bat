:: For determining the %biosver% for machines that need any token other than 2.

@echo off
FOR /F "tokens=2 " %%a in ('wmicbios.bat') do set biosver=%%a
echo "%biosver%" > C:\Users\%username%\Desktop\biosver.txt
pause