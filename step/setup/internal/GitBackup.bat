@echo off

set SOURCE=%USERPROFILE%\.gitconfig
set BACKUP=%USERPROFILE%\.gitconfig.backup
set MSG=File %SOURCE% backuped. Backup file : %BACKUP%

set CONFIG=
for /f %%i in ('git config --global --list') do set CONFIG=%%i

if not "%CONFIG%" == "" (
  echo "%MSG%"
  copy %SOURCE% %BACKUP%
  call %~dp0\GitClean.bat
  exit /b 0
)
if not exist %BACKUP% (
  echo "%MSG%"
  copy %SOURCE% %BACKUP%
  call %~dp0\GitClean.bat
) else (
  echo Nothing to backup.
)

