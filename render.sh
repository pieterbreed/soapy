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
logger "Found TOP: $TOP"

BASEURL="$WEBSERVER_PUBLIC_SCHEME://$WEBSERVER_PUBLIC_DNSNAME:$WEBSERVER_PUBLIC_PORT"
if [ "$BASEURL" = "://:" ];
then
    echo "Set variables: \$WEBSERVER_PUBLIC_SCHEME://\$WEBSERVER_PUBLIC_DNSNAME:\$WEBSERVER_PUBLIC_PORT"
    exit 1
fi

TO_CLEAN="$TOP/output/hugo"
logger "rm -rf $TO_CLEAN"
rm -rf "$TO_CLEAN"

logger "Generating hugo site"

mkdir -p "$TOP/output"
pushd "$TOP/src/hugo"
hugo --destination="../../output/hugo" --baseURL="$BASEURL" --verbose --buildDrafts 
popd

find "$TOP/output" -type f | xargs ls -l
echo "Rendered to $PROPERTY$TLD"



