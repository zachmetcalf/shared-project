:: Copyright (c) 2026 Zach Metcalf. All Rights Reserved.

@echo off
title clean
setlocal

set cwd=%~dp0
set projectdir=%cwd%..\..
set shareddir=%projectdir%\..\shared

for %%i in (.vs bin build install) do (
	if exist "%projectdir%\%%i" (
		rmdir "%projectdir%\%%i" /s /q
		if errorlevel 1 exit /b 1
	)
)

call "%shareddir%\scripts\setup\clean.bat"
if errorlevel 1 exit /b 1

echo clean completed
exit /b 0
