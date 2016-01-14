#!/bin/bash

# environment loaded at all? ||
if ! test ".$SOAPY_CONFIG_HAS_BEEN_LOADED" = ".1";
then
    echo "Load the environment first"
    exit 1
fi

# we support the most simplistic ansible dynamic inventory available
PARAMS="`echo -e \"$@\" | tr -d '[[:space:]]'`"

if [[ "--list" != "$PARAMS" ]]
then
    echo "this script only supports the '--list' option"
fi

# after all that, only print an env variable :)
echo "$ANSIBLE_INVENTORY"
