::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: setup.bat
::
:: Zach Metcalf
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@echo off
title setup

set cwd=%~dp0
set thirdpartydir=%cwd%..\..\3rdparty
set shareddir=%cwd%..\..\shared
set downloadsdir=%thirdpartydir%\downloads
set libsdir=%thirdpartydir%\libs
set toolsdir=%thirdpartydir%\tools
set scriptsdir=%shareddir%\scripts

if not exist %thirdpartydir% (
    mkdir %thirdpartydir%
)

if not exist %downloadsdir% (
    mkdir %downloadsdir%
)

if not exist %libsdir% (
    mkdir %libsdir%
)

if not exist %toolsdir% (
    mkdir %toolsdir%
)

pushd %downloadsdir%

if not exist %toolsdir%\premake (
    mkdir %toolsdir%\premake
)
curl -L --output premake.zip https://github.com/premake/premake-core/releases/download/v5.0.0-beta2/premake-5.0.0-beta2-windows.zip
tar -xf premake.zip -C %toolsdir%/premake

popd

pushd %thirdpartydir%

call :SetupGitRepo Catch2 devel https://github.com/catchorg/Catch2
call :SetupGitRepo dirent master https://github.com/tronkko/dirent
call :SetupGitRepo IconFontCppHeaders main https://github.com/juliettef/IconFontCppHeaders
call :SetupGitRepo imgui docking https://github.com/ocornut/imgui
call :SetupGitRepo implot master https://github.com/epezent/implot
call :SetupGitRepo rapidjson master https://github.com/tencent/rapidjson
call :SetupGitRepo stb master https://github.com/nothings/stb

call :SetupGitRepo vcpkg master https://github.com/microsoft/vcpkg

pushd vcpkg
call bootstrap-vcpkg.bat
vcpkg.exe install cpprestsdk cpprestsdk:x64-windows
vcpkg.exe install curl curl:x64-windows
vcpkg.exe upgrade --no-dry-run
popd

popd

if not %ERRORLEVEL% == 0 (
    echo setup failed
    exit /b 1
)

echo setup succeeded
exit /b 0

:SetupGitRepo
setlocal
set repo=%~1
set branch=%~2
set url=%~3
if not exist %repo% (
    git clone --branch %branch% %url%
) else (
    pushd %repo%
    git pull
    popd
)
endlocal
exit /b 0
