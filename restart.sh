#!/bin/bash

# restart jobs go here
BUILDLIST='qa1 qa2 steamqa'
SKYPE_NAME=$( echo "$SKYPE_FULLNAME" | awk '{ print $1; }' )
if [ $# -lt 1 ]
then
        echo 'Use it like this: "!restart $OPTION" ;). For a list of options, type "!restart list".'
        exit
fi

case "$1" in

list)  echo "Hey $SKYPE_NAME ;)! I can restart these java servers for you :P:"
       echo -n "$BUILDLIST"
    ;;
qa1) curl --silent --user bot:f23a8e133d4f4e713a53987d1a28c687 http://jenkins.redpointlabs.com:8080/jenkins/view/BLOODREALM_QA/job/RESTART_QA1_TOMCAT/build
               if [[ "$?" == "0" ]]; then
                 echo "Got it, $SKYPE_NAME ;). Restarting qa1 server...."
               else
                 echo "uh, uh. Something went wrong buddy."
               fi

    ;;
qa2) curl --silent --user bot:f23a8e133d4f4e713a53987d1a28c687 http://jenkins.redpointlabs.com:8080/jenkins/view/BLOODREALM_QA/job/RESTART_QA2_TOMCAT/build
               if [[ "$?" == "0" ]]; then
                 echo "Got it, $SKYPE_NAME ;). Restarting qa2 server...."
               else
                 echo "uh, uh. Something went wrong buddy."
               fi
    ;;
steamqa) curl --silent --user bot:f23a8e133d4f4e713a53987d1a28c687 http://jenkins.redpointlabs.com:8080/jenkins/view/BLOODREALM_QA/job/RESTART_STEAMQA_TOMCAT/build
               if [[ "$?" == "0" ]]; then
                 echo "Got it, $SKYPE_NAME ;). Restarting steamqa server...."
               else
                 echo "uh, uh. Something went wrong buddy."
               fi

    ;;
esac
