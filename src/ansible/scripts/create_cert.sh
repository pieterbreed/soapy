#!/bin/bash

set -e
set -x

pushd ~/letsencrypt
./letsencrypt-auto certonly --webroot -w /usr/share/nginx/soapshop/ -d soapshop.pb.co.za
popd
