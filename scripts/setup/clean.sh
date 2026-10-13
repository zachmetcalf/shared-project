# Copyright (c) 2026 Zach Metcalf. All Rights Reserved.

#!/usr/bin/env bash
set -e

echo -n -e "\033]0;clean\007"

cwd=$(cd "$(dirname "$0")" && pwd)
projectdir="$cwd/../.."
shareddir="$projectdir/../shared"

rm -rf "$projectdir/.vs"
rm -rf "$projectdir/bin"
rm -rf "$projectdir/build"
rm -rf "$projectdir/install"

bash "$shareddir/scripts/setup/clean.sh"

echo clean completed
exit 0
