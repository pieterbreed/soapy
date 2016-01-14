# file to be sourced for environment variables from bash

WHEREAMI="`dirname \"$BASH_SOURCE\"`"
WHEREAMI="`(cd \"$WHEREAMI\" && pwd)`"

export SOAPY_CONFIG_HAS_BEEN_LOADED=1

export WEBSERVER_PUBLIC_SCHEME="http"
export WEBSERVER_PUBLIC_DNSNAME="`hostname`"
export WEBSERVER_PUBLIC_PORT="8080"

export WEB_STATIC_CONTENT="`(cd \"$WHEREAMI/../output/hugo\" && pwd)`"

export PGSQL_USERNAME="`whoami`"
export PGSQL_DB_NAME="soapy"

read -d '' ANSIBLE_INVENTORY <<EOF
{
  "webservers": {
    "hosts": [ "localhost" ],
    "vars": {
      "ansible_connection": "local"
    }
  },
  "_meta": {
    "hostvars": {
      "localhost": { 
        "nginx_config_dest": "/usr/local/etc/nginx/servers/$WEBSERVER_PUBLIC_DNSNAME.conf",
        "static_html": "$WEB_STATIC_CONTENT" 
      }
    }
  }
}
EOF

export ANSIBLE_INVENTORY
