::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: setup.bat
::
:: Zach Metcalf
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@echo off
title setup

set cwd=%~dp0
set projectdir=%cwd%..\..
set shareddir=%projectdir%\..\shared

pushd %projectdir%\..

call :SetupGitRepo shared main https://github.com/zachmetcalf/shared

popd

pushd %shareddir%\scripts\setup

start /wait /b cmd /c setup.bat

popd

if not %ERRORLEVEL% == 0 (
    echo setup failed
    exit /b 1
)

echo setup succeeded
exit /b 0

:SetupGitRepo
setlocal
set repo=%~1
set branch=%~2
set url=%~3
if not exist %repo% (
    git clone --branch %branch% %url%
) else (
    pushd %repo%
    git pull
    popd
)
endlocal
exit /b 0
