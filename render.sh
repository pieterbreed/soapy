#!/bin/bash

function log {
    echo -e "########################################\n$1" > /dev/stderr
}

########################################

TOP="`dirname \"$BASH_SOURCE\"`"              # relative
TOP="`( cd \"$TOP\" && pwd )`"  # absolutized and normalized
if [ -z "$TOP" ]
then
  # error; for some reason, the path is not accessible
  # to the script (e.g. permissions re-evaled after suid)
  exit 1  # fail
fi
  
log "Found TOP at: $TOP"

########################################

rm -rf "$TOP/output/hugo"
mkdir -p "$TOP/output"

pushd "$TOP/src/hugo"
hugo --verbose --buildDrafts
popd

find "$TOP/output" -type f -name "*.html" | xargs ls -l



