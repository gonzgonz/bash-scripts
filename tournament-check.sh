#!/bin/bash

# script for Jenkins 'Tournament Controller' Task
# version 1.0 by Gonzalo Arce

if [ "$#" == "0" ]; then
    echo 'You must provide URL PREFIX as an argument. Example: tournament-check stage.bloodrealm.com'
    exit 1
fi

PREFIX_URL="$1"
CURL=$(which curl)
PRETTIFY='python2.7 -mjson.tool'

$CURL -v -s http://$PREFIX_URL/services/tournament/ranking/run -H "user:bloodrealm" -H "password:R3" -H "Accept:application/json" |  $PRETTIFY

CURL_RTVAL="$?"

echo '#####################################################################################'
echo '#####################################################################################'

if [ "$CURL_RTVAL" -ne "0" ]; then
   echo 'Something went wrong, please verify.'
else
   echo 'Tournament check completed successfully.'
fi

echo -e '\n'
