#!/bin/bash

set -e
set -x

[[ ".$SOAPY_CONFIG_HAS_BEEN_LOADED" == ".1" ]]

src/bash/check_nginx_is_running.sh
