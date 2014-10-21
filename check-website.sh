#!/bin/bash

# Script to check a website health (with help from other friendly sites :)
# Parses the output of curl command from the website

WEBSITE=${1}

case "${WEBSITE}" in

 facebook|twitter|gmail|skype)

     IFS=$'\n'; arr=( $(curl --silent http://downrightnow.com/${WEBSITE} | grep -i 'class="status status') );

     STATUS="$(echo ${arr[0]} | awk -F[\>\<] '{print $3;}')"
     USER_REPORTS="$(echo ${arr[1]} | cut -d '"' -f4)"
     TWITTER_REPORTS="$(echo ${arr[2]} | cut -d '"' -f4)"
     FEEDS_OA_REPORTS="$(echo ${arr[3]} | cut -d '"' -f4)"
     OTHER="$(echo ${arr[4]} | cut -d '"' -f4)"

     #STATUS="${STATUS}", User reports: "${USER_REPORTS}", Twitter reports: "${TWITTER_REPORTS}", Feeds and Announcements: "${FEEDS_OA_REPORTS}", Other: "${OTHER}""
 
     ;;
   
  *)
     STATUS="$(curl -s http://www.downforeveryoneorjustme.com/"${WEBSITE}".com | grep "${WEBSITE}" | grep -E -o -i  '(up|down)')"
 
esac



# Nagios codes


if echo "${STATUS}" | grep -E -i '(down|problem|error)' > /dev/null
then
 RETVAL="2"
elif echo "${STATUS}" | grep -E -i '(up|ok)' > /dev/null
then
 RETVAL="0"
else
 RETVAL="1"
fi

echo "Tested "${WEBSITE^}" Status: "${STATUS^}" "
exit ${RETVAL}
