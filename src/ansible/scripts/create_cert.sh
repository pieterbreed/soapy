#!/bin/bash

set -e
set -x

pushd ~/letsencrypt
./letsencrypt-auto certonly --webroot -w "/usr/share/nginx/$PROPERTY/" -d "$PROPERTY"
popd
