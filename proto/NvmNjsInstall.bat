@echo off

where choco
if %errorlevel% neq 0
echo "Program Chocolatey not found."
set /P answer="Do you want to install Chocholate now? (y/n)"

if  %answer% == "y" || %answer% == "Y" (
  runas /user:Administator "cmd.exe /C @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin""
)

set VERSION=%1

choco install nvm -y

if "%VERSION%" == "" (
  set VERSION=14.15.4
)

nvm install 14.15.4

