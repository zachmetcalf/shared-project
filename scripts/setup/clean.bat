:: Copyright (c) 2026 Zach Metcalf. All Rights Reserved.

@echo off
title clean

set cwd=%~dp0
set projectdir=%cwd%..\..
set shareddir=%projectdir%\..\shared

pushd %projectdir%

rmdir .vs /s /q
rmdir bin /s /q
rmdir build /s /q
rmdir install /s /q

popd

pushd %shareddir%\scripts\setup

start /wait /b cmd /c clean.bat

popd

if not %ERRORLEVEL% == 0 (
    echo clean failed
    exit /b 1
)

echo clean succeeded
exit /b 0
