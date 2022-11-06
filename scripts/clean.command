################################################################################################################################################################
## clean.command
##
## Zach Metcalf
################################################################################################################################################################

#!/bin/sh
set +e
echo -n -e "\033]0;clean\007"

cwd=$(cd "$(dirname "$0")"; pwd)
projectdir=$cwd/..
thirdpartydir=$projectdir/../3rdparty
shareddir=$projectdir/../shared
toolsdir=$thirdpartydir/tools
scriptsdir=$projectdir/scripts

script=$scriptsdir/premake/premake.lua
action=clean

cd $toolsdir
./premake/premake5 --file=$script $action --root=$shareddir --3rdparty=$thirdpartydir --shared=$shareddir

error=$?
if [ $error != 0 ]; then
  echo clean failed
  exit 1
fi

echo clean succeeded
exit 0
