# Copyright (c) 2026 Zach Metcalf. All Rights Reserved.

#!/usr/bin/env bash
echo -n -e "\033]0;setup\007"

cwd=$(cd "$(dirname "$0")"; pwd)
projectdir="$cwd/../.."
shareddir="$projectdir/../shared"

pushd "$projectdir/.."

function SetupGitRepo()
{
	repo="$1"
	branch="$2"
	url="$3"

	if [ ! -d "$repo" ]; then
		git clone --branch "$branch" "$url" "$repo"
	else
		pushd "$repo"
		git pull
		popd
	fi
}

SetupGitRepo shared main https://github.com/zachmetcalf/shared

popd

pushd "$shareddir/scripts/setup"

./setup.sh

popd

echo setup completed
exit 0
