#!/bin/bash

# script for running test queries against recently deployed bloodrealm environments

URL_PREFIX="$1"

echo "testing ${URL_PREFIX}/services/game/abilities"
curl -s -v  ${URL_PREFIX}/services/game/abilities -X POST -H "Accept:application/json" | python -mjson.tool
echo '########################################################################################################'
sleep 2
echo "testing ${URL_PREFIX}/services/users/user/inventory/10"
sleep 2
curl -s -v ${URL_PREFIX}/services/users/user/inventory/10 -X POST -H "Accept:application/json" | python -mjson.tool
