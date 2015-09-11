#!/bin/bash

# This script configure CaTS proxies for Ubuntu/Debian 
# Proxy username and password can be specified as command line arguments
# or specify in environment variable PROXY_USERNAME and PROXY_PASSWORD
#
# Note: Reboot (restart X) is required for X window applications to pick
#       up the chagnes
#
#set -xe
echo "Setting proxy for the machine ... "
[ -z "$PROXY_HOST" ] && PROXY_HOST=10.44.41.228
[ -z "$PROXY_PORT" ] && PROXY_PORT=8080
#[ -n "$2" ] && PROXY_USERNAME=$2
#[ -n "$3" ] && PROXY_PASSWORD=$3
myproxy="http://$PROXY_HOST:$PROXY_PORT"

# Set Proxy
function setproxy() {
    sudo tee -a /etc/environment << EOF
    http_proxy="$myproxy"
    https_proxy="$myproxy"
    ftp_proxy="$myproxy"
    no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
    HTTP_PROXY="$myproxy"
    HTTPS_PROXY="$myproxy"
    FTP_PROXY="$myproxy"
    NO_PROXY="localhost,127.0.0.1,localaddress,.localdomain.com"
    alias curl="curl -x $myproxy"

EOF

    sudo tee /etc/apt/apt.conf.d/95proxies << EOF
    Acquire::http::proxy "http://$PROXY_HOST:$PROXY_PORT/";
    #Acquire::ftp::proxy "ftp://$PROXY_HOST:$PROXY_PORT/";
    Acquire::https::proxy "https://$PROXY_HOST:$PROXY_PORT/";
EOF
}

#Unset Proxy
function unsetproxy() {
    sudo rm /etc/environment
    sudo tee /etc/environment << EOF
EOF

}

function usage() {
    echo "Usage $0 [on|off] 
    echo "Turn on or off CaTS proxy"
    echo
    echo "  e.g: $0 on 
    echo "       $0 off"
    echo 
}

if [ "$1" == "on" ]; then
#    if [ -z "$PROXY_USERNAME" -o -z "$PROXY_PASSWORD" ]; then
#        usage
#        exit 1
#    fi
    setproxy
elif [ "$1" == "off" ]; then
    unsetproxy
else
    usage
fi

