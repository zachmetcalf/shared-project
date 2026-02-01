:: Copyright (c) 2026 Zach Metcalf. All Rights Reserved.

@echo off
title standards

set cwd=%~dp0
set projectdir=%cwd%..\..
set tempdir=%projectdir%\.standards

if exist %tempdir% (
	rmdir /s /q %tempdir%
)

mkdir %tempdir%

pushd %tempdir%

call :SetupGitRepo standards main https://github.com/zachmetcalf/zachmetcalf

popd

copy /Y "%tempdir%\standards\.editorconfig"   "%projectdir%\.editorconfig"   >nul
copy /Y "%tempdir%\standards\.gitattributes"  "%projectdir%\.gitattributes"  >nul
copy /Y "%tempdir%\standards\.gitignore"      "%projectdir%\.gitignore"      >nul
copy /Y "%tempdir%\standards\.clang-tidy"     "%projectdir%\.clang-tidy"     >nul

if not exist "%projectdir%\.vscode" (
	mkdir "%projectdir%\.vscode"
)

copy /Y "%tempdir%\standards\.vscode\settings.json" "%projectdir%\.vscode\settings.json" >nul

set error=%ERRORLEVEL%

rmdir %tempdir% /s /q

if not %error% == 0 (
	echo standards failed
	exit /b 1
)

echo standards succeeded
exit /b 0

:SetupGitRepo
setlocal
set repo=%~1
set branch=%~2
set url=%~3
if not exist %repo% (
    git clone --branch %branch% %url% %repo%
) else (
	pushd %repo%
	git pull
	popd
)
endlocal
exit /b 0
