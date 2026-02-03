:: Copyright (c) 2026 Zach Metcalf. All Rights Reserved.

@echo off
title clean

set cwd=%~dp0
set projectdir=%cwd%..\..
set shareddir=%projectdir%\..\shared

pushd "%projectdir%"

if exist .vs rmdir .vs /s /q
if exist bin rmdir bin /s /q
if exist build rmdir build /s /q
if exist install rmdir install /s /q

popd

pushd "%shareddir%\scripts\setup"

call clean.bat

popd

echo clean completed
exit /b 0
