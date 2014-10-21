#!/bin/bash

# Checks online users in all three BloodRealm prod environments

CURL="$(which curl)"
FB_JSON='http://server01.bloodrealm.com:8080/mp/onlineusers'
KONG_JSON='http://server01.bloodrealm.com:8080/mp-kong/onlineusers'
KB_JSON='http://server01.bloodrealm.com:8080/mp-kabam/onlineusers'
MOBILE_JSON='http://qa02.bloodrealm.com:8080/mp-stage/onlineusers'

# Get the values from the json data and calculate the users count

FB_N="$(${CURL} ${FB_JSON} -s | grep -o 'token'| wc -l)"
KONG_N="$(${CURL} ${KONG_JSON} -s | grep -o 'token'| wc -l)"
KB_N="$(${CURL} ${KB_JSON} -s | grep -o 'token'| wc -l)"
MOBILE_N="$(${CURL} ${MOBILE_JSON} -s | grep -o 'token'| wc -l)"
TOT_N="$((${FB_N} + ${KONG_N} + ${MOBILE_N} + ${KB_N}))"

# Cacti likes output formatted this way:

echo "fb_users:${FB_N} kong_users:${KONG_N} kabam_users:${KB_N} mobile_users:${MOBILE_N} total_users:${TOT_N}"
