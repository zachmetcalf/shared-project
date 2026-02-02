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

popd

pushd %shareddir%\scripts\utils

call zip.bat

popd

echo zip completed
exit /b 0
