################################################################################################################################################################
## premake.command
##
## Zach Metcalf
################################################################################################################################################################

#!/bin/sh
set +e
echo -n -e "\033]0;setup\007"

cwd=$(cd "$(dirname "$0")"; pwd)
projectdir=$cwd/../..
shareddir=$projectdir/../shared

function SetupGitRepo()
{
    repo=$1;
    branch=$2;
    url=$3;
    if [ ! -d "$repo" ]; then
        git clone --branch $branch $url
    else
        pushd $repo
        git pull
        popd
    fi
}

pushd $projectdir/..

SetupGitRepo shared main https://github.com/zachmetcalf/shared

popd

pushd $shareddir/scripts/setup

source setup.command

popd

error=$?
if [ $error != 0 ]; then
  echo setup failed
  exit 1
fi

echo setup succeeded
exit 0
