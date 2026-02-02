# Copyright (c) 2026 Zach Metcalf. All Rights Reserved.

#!/usr/bin/env bash
echo -n -e "\033]0;clean\007"

cwd=$(cd "$(dirname "$0")"; pwd)
projectdir=$cwd/../..
shareddir=$projectdir/../shared

pushd $shareddir/scripts/setup

./clean.sh

popd

pushd $projectdir

rm -rf .vs
rm -rf bin
rm -rf build
rm -rf install

popd

echo clean completed
exit 0
