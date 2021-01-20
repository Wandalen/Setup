@echo off

where choco.exe
if %ERRORLEVEL% NEQ 0
echo "Program Chocolatey not found."
set /P ANSWER="Do you want to install Chocolatey now? (y/n)"

for /F %i in ('whoami') do
set USERNAME=%i

if  %ANSWER% == "y" OR %ANSWER% == "Y" (
  runas /user:%USERNAME% "cmd.exe /C @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin""
)

set VERSION=%1

choco install nvm -y

if "%VERSION%" == "" (
  set VERSION=14.15.4
)

nvm install 14.15.4

