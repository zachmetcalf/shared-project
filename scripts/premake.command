################################################################################################################################################################
## premake.command
##
## Zach Metcalf
################################################################################################################################################################

#!/bin/sh
set +e
echo -n -e "\033]0;premake\007"

cwd=$(cd "$(dirname "$0")"; pwd)
thirdpartydir=$cwd/../../3rdparty
shareddir=$cwd/../../shared
toolsdir=$thirdpartydir/tools
scriptsdir=$shareddir/scripts

script=$scriptsdir/premake/premake.lua
action=xcode4
backend=metal

cd $toolsdir
./premake/premake5 --file=$script $action --root=$shareddir --3rdparty=$thirdpartydir --shared=$shareddir --gfxapi=$backend

error=$?
if [ $error != 0 ]; then
  echo premake failed
  exit 1
fi

echo premake succeeded
exit 0
