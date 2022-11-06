################################################################################################################################################################
## premake.command
##
## Zach Metcalf
################################################################################################################################################################

#!/bin/sh
set +e
echo -n -e "\033]0;setup\007"

cwd=$(cd "$(dirname "$0")"; pwd)
thirdpartydir=$cwd/../../3rdparty
shareddir=$cwd/../../shared
downloadsdir=$thirdpartydir/downloads
libsdir=$thirdpartydir/libs
toolsdir=$thirdpartydir/tools
scriptsdir=$shareddir/scripts

mkdir -p $thirdpartydir
mkdir -p $downloadsdir
mkdir -p $libsdir
mkdir -p $toolsdir

pushd $downloadsdir

mkdir -p $toolsdir/premake
curl -L --output premake.zip https://github.com/premake/premake-core/releases/download/v5.0.0-beta2/premake-5.0.0-beta2-macosx.tar.gz
tar -xf premake.zip -C $toolsdir/premake

mkdir -p $libsdir/glfw
curl -L --output glfw.zip https://github.com/glfw/glfw/releases/download/3.3.8/glfw-3.3.8.bin.MACOS.zip
tar -xf glfw.zip -C $libsdir/glfw

popd

pushd $thirdpartydir

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

SetupGitRepo Catch2 devel https://github.com/catchorg/Catch2
SetupGitRepo dirent master https://github.com/tronkko/dirent
SetupGitRepo IconFontCppHeaders main https://github.com/juliettef/IconFontCppHeaders
SetupGitRepo imgui docking https://github.com/ocornut/imgui
SetupGitRepo implot master https://github.com/epezent/implot
SetupGitRepo rapidjson master https://github.com/tencent/rapidjson
SetupGitRepo stb master https://github.com/nothings/stb

SetupGitRepo glfw master https://github.com/glfw/glfw

popd

brew install cpprestsdk
brew install curl
brew upgrade

error=$?
if [ $error != 0 ]; then
  echo setup failed
  exit 1
fi

echo setup succeeded
exit 0
