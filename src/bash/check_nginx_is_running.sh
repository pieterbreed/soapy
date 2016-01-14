#!/bin/bash
set -x
set -e

WHEREAMI="`dirname \"$BASH_SOURCE\"`"
WHEREAMI="`(cd \"$WHEREAMI\" && pwd)`"

BASE_URL="$WEBSERVER_PUBLIC_SCHEME://$WEBSERVER_PUBLIC_DNSNAME:$WEBSERVER_PUBLIC_PORT"

# is nginx up and responding on the port at all?
curl "$BASE_URL" > /dev/null 2>&1

# is the nginx serving static content from hugo at all?
test "`cat \"$WHEREAMI/../hugo/static/soapy.marker\"`" = "`curl \"$BASE_URL/soapy.marker\" 2> /dev/null`"


