# Copyright (c) 2026 Zach Metcalf. All Rights Reserved.

#!/usr/bin/env bash
set +e
echo -n -e "\033]0;clean\007"

cwd=$(cd "$(dirname "$0")"; pwd)
projectdir=$cwd/../..
shareddir=$projectdir/../shared

pushd $projectdir

rm -rf .vs
rm -rf bin
rm -rf build
rm -rf install

popd

pushd $shareddir/scripts/setup

./clean.sh
error=$?

popd

if [ $error != 0 ]; then
  echo clean failed
  exit 1
fi

echo clean succeeded
exit 0
