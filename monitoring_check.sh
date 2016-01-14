#!/bin/bash

set -e
set -x

test ".$SOAPY_CONFIG_HAS_BEEN_LOADED" = ".1" # environment loaded at all?

# now just run the checking scripts one by one
src/bash/check_nginx_is_running.sh
