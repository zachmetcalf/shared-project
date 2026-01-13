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

powershell -NoProfile -Command "$paths=@();foreach($p in @('CMakeLists.txt','scripts','source')){if(Test-Path $p){$paths+=$p}};Compress-Archive -Force -Path $paths -DestinationPath '%zippath%'"

popd

if not %ERRORLEVEL% == 0 (
    echo zip failed
    exit /b 1
)

pushd %shareddir%\scripts\setup

start /wait /b cmd /c zip.bat

popd

if not %ERRORLEVEL% == 0 (
    echo zip failed
    exit /b 1
)

echo zip succeeded
exit /b 0
