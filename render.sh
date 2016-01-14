#!/bin/bash

########################################

TOP="`dirname \"$BASH_SOURCE\"`"              # relative
TOP="`( cd \"$TOP\" && pwd )`"  # absolutized and normalized
if [ -z "$TOP" ]
then
  # error; for some reason, the path is not accessible
  # to the script (e.g. permissions re-evaled after suid)
  exit 1  # fail
fi
  
echo "Found TOP at: $TOP" > /dev/stderr

########################################

pushd "$TOP/src/hugo"
rm -rf public/* && hugo --verbose --buildDrafts && find public -type f -name "*.html" | xargs ls -l
popd



