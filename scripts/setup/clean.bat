::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: clean.bat
::
:: Zach Metcalf
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@echo off
title clean

set cwd=%~dp0
set projectdir=%cwd%..\..

pushd %projectdir%

rmdir .vs /s /q
rmdir 3rdparty /s /q
rmdir bin /s /q
rmdir build /s /q
rmdir install /s /q

popd

if not %ERRORLEVEL% == 0 (
    echo clean failed
    exit /b 1
)

echo clean succeeded
exit /b 0
