@echo off
setlocal enabledelayedexpansion

set toolpath="%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
for /f "usebackq tokens=*" %%i in (`%toolpath% -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do (
  set InstallDir=%%i
)

if exist "%InstallDir%\VC\Auxiliary\Build\Microsoft.VCToolsVersion.default.txt" (
  set /p Version=<"%InstallDir%\VC\Auxiliary\Build\Microsoft.VCToolsVersion.default.txt"

  rem Trim
  set Version=!Version: =!
)

if "%Version%"=="" (
  echo "Install MSBuild Tools componets and SDK, please."
  exit 1
)

if not "%Version%"=="" (
  rem Example hardcodes x64 as the host and target architecture, but you could parse it from arguments
  "%InstallDir%\VC\Tools\MSVC\%Version%\bin\HostX64\x64\cl.exe" %*
)
endlocal

where git.exe
if %ERRORLEVEL% NEQ 0 (
  echo "Install Git, please."
  exit 1
)

where node.exe
if %ERRORLEVEL% NEQ 0 (
  call %~dp0\..\install\Nvm.bat
)

for /f %%i in ('node -v') do set RAW_VERSION=%%i
set /A VERSION=%RAW_VERSION:~1,2%
if %VERSION% LSS 14 (
  echo "Please, install NodeJs v14 or higher."
  exit 1
)

where python3
if %ERRORLEVEL% NEQ 0 (
  echo "Install Python v3, please."
)

call git clone https://github.com/Wandalen/wNodejsDevEnv.git
cd wNodejsDevEnv
call npm test
cd ..
rmdir /s /q wNodejsDevEnv
