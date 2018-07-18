:: For determining the output of the %biosver% variable in the installer so that new machines can be added.

@echo off
FOR /F "tokens=2 " %%a in ('wmicbios.bat') do set biosver=%%a
echo "%biosver%" > C:\Users\%username%\Desktop\biosver.txt
pause