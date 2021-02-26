@echo off

where choco.exe
if %ERRORLEVEL% NEQ 0 (
  echo Please, install the utility Chocolatey and then run the script
  echo Run next command in administrative shell to install utility :
  echo @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
  exit /b 
)

set VERSION=%1

choco install nvm -y

if "%VERSION%" == "" (
  set VERSION=14.15.4
)

nvm install 14.15.4

