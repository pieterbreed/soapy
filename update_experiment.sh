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

SRC_NAME="$1"
if [ ".$SRC_NAME" = "." ]; then
    SRC_NAME="soapshop"
fi
  
pushd "$TOP/src"

BRANCH_NAME=`git status -bs --porcelain | head -n 1 | cut -d' ' -f2 | cut -d '.' -f1`
DEST_NAME="$BRANCH_NAME"
if [ "$BRANCH_NAME" = "master" ]; then
    DEST_NAME="soapshop"
fi

logger "BRANCH_NAME=$BRANCH_NAME" 
(export DEST=$DEST_NAME; export SRC=$SRC_NAME; find . -type f -print0 | xargs -0 perl -i.bak -pe 's/$ENV{''SRC''}/$ENV{''DEST''}/g')
popd
