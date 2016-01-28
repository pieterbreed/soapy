#!/bin/bash

set -e
set -x

TOP="`dirname \"$BASH_SOURCE\"`"              # relative
TOP="`( cd \"$TOP\" && pwd )`"  # absolutized and normalized
if [ -z "$TOP" ]
then
  # error; for some reason, the path is not accessible
  # to the script (e.g. permissions re-evaled after suid)
  exit 1  # fail
fi

SRC_BRANCH="$1"
if [ ".$SRC_BRANCH" = "." ]; then
    SRC_BRANCH="soapshop"
fi
  
logger "Found TOP at: $TOP"

pushd "$TOP/src"
BRANCH_NAME=`git status -bs --porcelain | head -n 1 | cut -d' ' -f2 | cut -d '.' -f1`
logger "BRANCH_NAME=$BRANCH_NAME" 
(export BRANCH=$BRANCH_NAME; export SRC_BRANCH; find . -type f -print0 | xargs -0 perl -i.bak -pe 's/$ENV{''SRC_BRANCH''}/$ENV{''BRANCH''}/g')
popd
