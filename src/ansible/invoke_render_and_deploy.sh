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
  
COPY="$1"
if ! [ ".$COPY" = "." ]; then
    COPY="--tags=copy-html"
fi

pushd "$TOP"

pushd ../..
./render.sh
popd

ansible-playbook deploy_web.yml $COPY 

terminal-notifier -title "Done" \
                  -message "deploy finished $PROPERTY$TLD" \
                  -appIcon "$TOP/../../output/hugo/apple-touch-icon.png" \
                  --open "$WEBSERVER_PUBLIC_DNSNAME"

popd
