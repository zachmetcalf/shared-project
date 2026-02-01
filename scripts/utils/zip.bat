:: Copyright (c) 2026 Zach Metcalf. All Rights Reserved.

@echo off
title zip

set cwd=%~dp0
set projectdir=%cwd%..\..
set shareddir=%projectdir%\..\shared

pushd %projectdir%

for %%i in ("%projectdir%") do set projectname=%%~ni

set zipdir=%projectdir%\..
set zipname=%projectname%.zip
set zippath=%zipdir%\%zipname%

if exist %zippath% (
	del %zippath%
)

powershell -NoProfile -Command "Compress-Archive -Force -Path (Get-ChildItem -LiteralPath '.' -File | Select-Object -ExpandProperty FullName) -DestinationPath '%zippath%'"
powershell -NoProfile -Command "Compress-Archive -Update -Path '.vscode','scripts' -DestinationPath '%zippath%'"
set error=%ERRORLEVEL%

popd

if not %error% == 0 (
	echo zip failed
	exit /b 1
)

pushd %shareddir%\scripts\utils

call zip.bat
set error=%ERRORLEVEL%

popd

if not %error% == 0 (
	echo zip failed
	exit /b 1
)

echo zip succeeded
exit /b 0
