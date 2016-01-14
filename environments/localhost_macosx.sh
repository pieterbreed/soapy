# file to be sourced for environment variables from bash

WHEREAMI="`dirname \"$BASH_SOURCE\"`"
WHEREAMI="`(cd \"$WHEREAMI\" && pwd)`"

export SOAPY_CONFIG_HAS_BEEN_LOADED=1

export WEBSERVER_PUBLIC_SCHEME="http"
export WEBSERVER_PUBLIC_DNSNAME="localhost"
export WEBSERVER_PUBLIC_PORT="8080"

export WEB_STATIC_CONTENT="`(cd \"$WHEREAMI/../output/hugo\" && pwd)`"
