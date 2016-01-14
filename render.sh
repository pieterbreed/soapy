#!/bin/bash

########################################

function log {
    echo -e "########################################\n# $1\n########################################\n" > /dev/stderr
}

########################################

# environment loaded at all? ||
if ! test ".$SOAPY_CONFIG_HAS_BEEN_LOADED" = ".1";
then
    log "Load the environment first"
    exit 1
fi

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

TO_CLEAN="$TOP/output/hugo"
log "Cleaning up $TO_CLEAN"
rm -rf "$TO_CLEAN"

log "Generating hugo site"

mkdir -p "$TOP/output"
pushd "$TOP/src/hugo"
hugo --verbose --buildDrafts
popd

log "Generated output"

find "$TOP/output" -type f | xargs ls -l



