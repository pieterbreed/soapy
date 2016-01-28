#!/bin/bash

set -e
set -x

pushd ~/letsencrypt
./letsencrypt-auto certonly --webroot -w /usr/share/nginx/experiment/ -d experiment.pb.co.za
popd
