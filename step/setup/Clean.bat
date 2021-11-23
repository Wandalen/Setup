@echo off

set SOURCE=%USERPROFILE%\.gitconfig

call %~dp0\internal\Backup.bat

echo. 2> %SOURCE%
echo All settings from file %SOURCE% are cleaned.
