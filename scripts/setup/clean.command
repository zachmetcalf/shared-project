################################################################################################################################################################
## clean.command
##
## Zach Metcalf
################################################################################################################################################################

#!/bin/sh
set +e
echo -n -e "\033]0;clean\007"

cwd=$(cd "$(dirname "$0")"; pwd)
projectdir=$cwd/../..
shareddir=$projectdir/../shared

pushd $projectdir

rm -rf bin
rm -rf build
rm -rf install

popd

pushd $shareddir/scripts/setup

source clean.command

popd

error=$?
if [ $error != 0 ]; then
  echo clean failed
  exit 1
fi

echo clean succeeded
exit 0
