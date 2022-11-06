::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: clean.bat
::
:: Zach Metcalf
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@echo off
title premake

set cwd=%~dp0
set thirdpartydir=%cwd%..\..\3rdparty
set shareddir=%cwd%..\..\shared
set toolsdir=%thirdpartydir%\tools
set scriptsdir=%shareddir%\scripts

set script=%scriptsdir%\premake\premake.lua
set action=clean

cd %toolsdir%
.\premake\premake5 --file=%script% %action% --root=%shareddir% --3rdparty=%thirdpartydir% --shared=%shareddir%

if not %ERRORLEVEL% == 0 (
    echo clean failed
    exit /b 1
)

echo clean succeeded
exit /b 0
