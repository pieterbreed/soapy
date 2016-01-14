#!/bin/bash

set -e
set -x

ENV_LOADED_ERROR="Did you load the environment?"

test "$ENV_LOADED_ERROR.$SOAPY_CONFIG_HAS_BEEN_LOADED" = "$ENV_LOADED_ERROR.1" # environment loaded at all?

# now just run the checking scripts one by one
src/bash/check_nginx_is_running.sh

echo -e "########################################\n# IF YOU SEE THIS, EVERYTHING IS COOL! #\n########################################"
