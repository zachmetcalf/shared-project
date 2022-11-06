::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: clean.bat
::
:: Zach Metcalf
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@echo off
title premake

set cwd=%~dp0
set projectdir=%cwd%..
set thirdpartydir=%projectdir%\..\3rdparty
set shareddir=%projectdir%\..\shared
set toolsdir=%thirdpartydir%\tools
set scriptsdir=%projectdir%\scripts

set script=%scriptsdir%\premake\premake.lua
set action=clean

cd %toolsdir%
.\premake\premake5 --file=%script% %action% --root=%projectdir% --3rdparty=%thirdpartydir% --shared=%shareddir%

if not %ERRORLEVEL% == 0 (
    echo clean failed
    exit /b 1
)

echo clean succeeded
exit /b 0
