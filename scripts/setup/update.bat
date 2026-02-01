:: Copyright (c) 2026 Zach Metcalf. All Rights Reserved.

@echo off
title update

set cwd=%~dp0
set projectdir=%cwd%..\..
set shareddir=%projectdir%\..\shared

pushd %projectdir%\..

call :SetupGitRepo shared main https://github.com/zachmetcalf/shared

popd

pushd %shareddir%\scripts\setup

call update.bat
set error=%ERRORLEVEL%

popd

if not %error% == 0 (
	echo update failed
	exit /b 1
)

echo update succeeded
exit /b 0

:SetupGitRepo
setlocal
set repo=%~1
set branch=%~2
set url=%~3
if not exist %repo% (
	git clone --branch %branch% %url% %repo%
) else (
	pushd %repo%
	git pull
	popd
)
endlocal
exit /b 0
