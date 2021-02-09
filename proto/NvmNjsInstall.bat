@echo off

where choco.exe
if %ERRORLEVEL% NEQ 0 (
  REM  --> Check for permissions
  if "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
    >nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
  ) else (
    >nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
  )

  REM --> If error flag set, we do not have admin.
  if '%errorlevel%' NEQ '0' (
    goto UACPrompt
  ) else (
    goto gotAdmin
  )

  :UACPrompt
  echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
  set params= %*
  echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"
  "%temp%\getadmin.vbs"
  del "%temp%\getadmin.vbs"
  exit /B

  :gotAdmin
  pushd "%CD%"
  CD /D "%~dp0"

  echo "Program Chocolatey not found."
  set /P ANSWER="Do you want to install Chocolatey now? (y/n)"
  if  %ANSWER% == "y" OR %ANSWER% == "Y" (
    @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
  )
)

set VERSION=%1

choco install nvm -y

if "%VERSION%" == "" (
  set VERSION=14.15.4
)

nvm install 14.15.4

