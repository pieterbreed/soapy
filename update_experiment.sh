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
  
logger "Found TOP at: $TOP"

pushd "$TOP/src"
BRANCH_NAME=`git status -bs --porcelain | head -n 1 | cut -d' ' -f2`
logger "BRANCH_NAME=$BRANCH_NAME" 
(export BRANCH=$BRANCH_NAME; find . -type f -print0 | xargs -0 perl -i.bak -pe 's/soapshop/$ENV\{\'BRANCH\'\}/g')
popd
