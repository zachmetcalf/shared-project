::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: premake.bat
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
set action=vs2019
set backend=dx11

cd %toolsdir%
.\premake\premake5 --file=%script% %action% --root=%shareddir% --3rdparty=%thirdpartydir% --shared=%shareddir% --gfxapi=%backend%

if not %ERRORLEVEL% == 0 (
    echo premake failed
    exit /b 1
)

echo premake succeeded
exit /b 0
