@echo off

set NAME=%1
set EMAIL=%2

git config --global core.autocrlf false
git config --global core.ignorecase false
git config --global core.fileMode false
git config --global credential.helper store

if not "%NAME%" == "" (
  git config --global user.name "%NAME%"
  git config --global url."https://%NAME%@github.com".insteadOf "https://github.com"
  git config --global url."https://%NAME%@bitbucket.org".insteadOf "https://bitbucket.org"
)

if not "%EMAIL%" == "" (
  git config --global user.email "%EMAIL%"
)

