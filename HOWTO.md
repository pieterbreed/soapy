# HOWTO

As in, how do I use this thing?

## Configuration

The `./environments` folder is in the `.gitignore` file and is meant to host your _sensitive_ environment configuration.

The first thing you want to do is source it into the shell using the `.` operator, eg:

```
$ . environments/localhost_macosx.sh
```

## Example Configuration

```
# file to be sourced for environment variables from bash

export SOAPY_CONFIG_HAS_BEEN_LOADED=1
export WEBSERVER_PUBLIC_DNSNAME=localhost
export WEBSERVER_PUBLIC_PORT=8080
```
