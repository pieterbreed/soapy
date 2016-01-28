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

export WEBSERVER_PUBLIC_DNSNAME=experiment.pb.co.za
export WEBSERVER_PUBLIC_PORT=443

pushd "$TOP"

pushd ../..
./render.sh
popd

ansible-playbook provision_web.yml 

terminal-notifier -title "Done" \
                  -message "deploy finished" \
                  -appIcon "$TOP/../../output/hugo/apple-touch-icon.png" \
                  --open "$WEBSERVER_PUBLIC_DNSNAME"

popd
