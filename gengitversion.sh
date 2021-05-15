#!/bin/bash
set -euo pipefail
#$1 = directory of git repo
#$2 = optional ouput path, default ./git_version.h
#$3 = optional prefix, default is GIT




if [ "$1" != "" ]; then
    GITPATH=$1
else
    GITPATH='./'
fi

if [ "$2" != "" ]; then
    HEADPATH=$2
else
    HEADPATH='./git_version.txt'
fi


#echo "Generating header for git hash"

GIT_HEADER="$HEADPATH"

GIT_BRANCH=$(git --git-dir=$GITPATH/.git --work-tree=$GITPATH rev-parse --abbrev-ref HEAD)
GIT_VERSION=$(git --git-dir=$GITPATH/.git --work-tree=$GITPATH log --format=%h)

set +e
git --git-dir=$GITPATH/.git --work-tree=$GITPATH diff-index --quiet HEAD --
GIT_MODIFIED=$?
set -e

REPO_NAME=$(basename $(git --exec-path=$GITPATH rev-parse --show-toplevel))


if [ $GIT_MODIFIED = 0 ]; then
echo $REPO_NAME "["$GIT_BRANCH"]" $GIT_VERSION > $GIT_HEADER
fi

if [ $GIT_MODIFIED = 1 ]; then
echo $REPO_NAME "["$GIT_BRANCH"]" $GIT_VERSION "(modified)"  > $GIT_HEADER
echo -e "\e[1;31m------------------------ WARNING ----------------------------"
echo -e "\e[1;31mgit repo "$REPO_NAME" ["$GIT_BRANCH"] modified"
echo -e "\e[1;31m-------------------------------------------------------------\e[1;m"

fi
