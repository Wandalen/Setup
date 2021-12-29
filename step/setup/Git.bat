@echo off

set NAME=%1
set EMAIL=%2

set FORMAT=Command format: "script_path [user.name] [user.email]"

for /f %%i in ('git config --get user.name') do set OLDNAME=%%i
if "%OLDNAME%" == "" (
  if "%NAME%" == "" (
    echo User name is not defined. Please, define user name. %FORMAT%
    exit /b 1
  )
)

for /f %%i in ('git config --get user.email') do set OLDEMAIL=%%i
if "%OLDEMAIL%" == "" (
  if "%EMAIL%" == "" (
    echo User email is not defined. Please, define user email. %FORMAT%
    exit /b 1
  )
)

call %~dp0\Backup.bat

git config --global core.autocrlf false
git config --global core.ignorecase false
git config --global core.fileMode false
git config --global credential.helper store

if not "%NAME%" == "" (
  git config --global user.name "%NAME%"
  if not "%OLDNAME%" == "" (
    git config --global --unset url.https://%OLDNAME%@github.com.insteadof
    git config --global --unset url.https://%OLDNAME%@bitbucket.org.insteadof
  )
  git config --global url."https://%NAME%@github.com".insteadOf "https://github.com"
  git config --global url."https://%NAME%@bitbucket.org".insteadOf "https://bitbucket.org"
)

if not "%EMAIL%" == "" (
  git config --global user.email "%EMAIL%"
)

git config --list --global --show-origin
