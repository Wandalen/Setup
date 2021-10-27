@echo off

set SOURCE=%USERPROFILE%\.gitconfig

call %~dp0\Backup.bat

echo All settings from file %SOURCE% are cleaned.
echo. 2> %SOURCE%
