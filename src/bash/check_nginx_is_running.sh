#!/bin/bash
set -x
set -e

curl "http://$WEBSERVER_PUBLIC_DNSNAME:$WEBSERVER_PUBLIC_PORT" > /dev/null 2>&1
