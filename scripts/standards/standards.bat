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

git clone --branch main https://github.com/zachmetcalf/zachmetcalf .

popd

if not exist %projectdir%\.vscode (
	mkdir %projectdir%\.vscode
)

copy /y %tempdir%\.vscode\settings.json %projectdir%\.vscode\settings.json >nul
copy /y %tempdir%\.vscode\tasks.json %projectdir%\.vscode\tasks.json >nul
copy /y %tempdir%\.clang-tidy %projectdir%\.clang-tidy >nul
copy /y %tempdir%\.editorconfig %projectdir%\.editorconfig >nul
copy /y %tempdir%\.gitattributes %projectdir%\.gitattributes >nul
copy /y %tempdir%\.gitignore %projectdir%\.gitignore >nul
copy /y %tempdir%\license.txt %projectdir%\license.txt >nul

rmdir /s /q %tempdir%

echo standards completed
exit /b 0
