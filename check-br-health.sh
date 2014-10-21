#!/bin/bash

# script for running test queries against recently deployed environments
# 

URL_PREFIX="$1"
HEADERS="/tmp/br-headers$$.txt"

# test connection with internal data files (json-files) on ${URL_PREFIX}/services/game/abilities"
if curl -s -D $HEADERS ${URL_PREFIX}/services/game/abilities -X POST -H "Accept:application/json" | grep 'AbilityTemplateName' > /dev/null
then 
 test1="OK"
else
 test1="ERROR"
fi

# test mongodb connectivity on ${URL_PREFIX}/services/users/user/inventory/10"
if curl -s ${URL_PREFIX}/services/users/user/inventory/10 -X POST -H "Accept:application/json" | grep 'deck' > /dev/null
then 
 test2="OK"
else
 test2="ERROR"
fi

# define some statuses
if echo "$test1" "$test2" | grep "OK" > /dev/null
then
 STATUS="OK"
elif echo "$test1" "$test2" | grep "ERROR" > /dev/null
then 
 STATUS="NOT OK"
else
 STATUS="UNKNOWN"
fi

# obtain game version from headers
GAME_VERSION="$(grep version $HEADERS | awk '{print $2;}' | tr -d [[:cntrl:]])"

RESULT="Tested $URL_PREFIX: Application status is "$STATUS". Game Version is "$GAME_VERSION", Json files are "$test1", Connectivity with mongodb is "$test2""
ERRORCOUNT="$(echo $RESULT | grep -o ERROR | wc -l)"

# STATUS DEFINITIONS FOR NAGIOS

if [[ "$ERRORCOUNT" -ge "2" ]]
then
 RETVAL=2

elif [[ "$ERRORCOUNT" == "1" ]]
then 
 RETVAL=1

else
if [[ "$ERRORCOUNT" == "0" ]]
then
 RETVAL=0
fi
fi

rm -f $HEADERS

echo $RESULT
exit $RETVAL
