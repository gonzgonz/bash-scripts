#!/bin/bash

# BUILDS JENKINS JOBS via SKYPE BOT

BUILDLIST='flash-prod | flash-stage | server-stage $VERSION | server-prod $VERSION | steam-mac $VERSION | steam-uploader | steam-constructor | web-version | android-version'
PARAM1=$2
PARAM2=$3
            

if [ $# -lt 1 ]
then
        echo 'Use this command like this, brah: "!build $JOB" ;). For a list of jobs I can build, type "!build list".'
        exit
fi

case "$1" in

list)  echo "I can build the following jobs for you:"
       echo -n "$BUILDLIST"
    ;;
restart-qa1)  curl --silent --user bot:xxxxxxxxxxxxxxx http://xxxxxxxxxxxxxxxxxxxxxxxxxx/job/RESTART_QA1_TOMCAT/build
               if [[ "$?" == "0" ]]; then
                 echo "Got it. Restarting qa1 server...."
               else
                 echo "uh, uh. Something went wrong buddy."
               fi
    
    ;;
restart-qa2)  curl --silent --user bot:xxxxxxxxxxxxxxxxxx http://XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/RESTART_QA2_TOMCAT/build
               if [[ "$?" == "0" ]]; then
                 echo "Got it. Restarting qa2 server...."
               else
                 echo "uh, uh. Something went wrong buddy."
               fi

    ;;

flash-prod)  curl --silent --user bot:xxxxxxxxxxxxxxxxxxxxxxx http://XXXXXXXXXXXXXXXXXXXXXXXXXXX/FLASH_PROD/build
               if [[ "$?" == "0" ]]; then
                 echo "Got it. Building flash movies for Production...."
               else
                 echo "uh, uh. Something went wrong buddy."
               fi

    ;;
flash-stage) curl --silent --user bot:xxxxxxxxxxxxxxxxxxxx http://XXXXXXXXXXXXXXXXXXXXXXXXXXFLASH_STAGE/build
               if [[ "$?" == "0" ]]; then
                 echo "Got it. Building flash movies for Stage web deployment...."
               else
                 echo "uh, uh. Something went wrong buddy. Did you supply the parameters for this build?"
               fi
    ;;
server-stage) curl --silent --user botddddddddddddddddddd "http:/ddddddddddddddddd/jenkins/view/BLOODREALM_QA/job/MAGICEMPIRE-STAGE/buildWithParameters?VERSION=$PARAM1"
               if [[ "$?" == "0" ]]; then
                 echo "Building war and deploying to Amazon S3...."
               else
                 echo "uh, uh. Something went wrong buddy. Did you supply the parameters for this build?"
               fi
   ;;
server-prod) curl --silent --user bot:ddddddddddddddddddddd "http://dddddddddddddddddddddddOODREALM%20PROD/job/MAGICEMPIRE_PROD/buildWithParameters?VERSION=$PARAM1"
               if [[ "$?" == "0" ]]; then
                 echo "Building war and deploying to Amazon S3...."
               else
                 echo "uh, uh. Something went wrong buddy. Did you supply the parameters for this build?"
               fi
   ;;
steam-mac) curl --silent --user bot:xxxxxxxxxxxxxxxxxxxxxxxxx "http://dddddddddddddddddddddddddM_STEAM/job/BLOODREALM_STEAMAIR_MAC/buildWithParameters?VERSION=${PARAM1}&CHANGELOG=${PARAM2}"
               if [[ "$?" == "0" ]]; then
                 echo "Building Bloodrealm Steam .app for mac...."
                 echo "with VERSION: "${PARAM1}" and CHANGELOG: "${PARAM2}""
                else
                 echo "uh, uh. Something went wrong "$(echo $SKYPE_FULLNAME | awk '{print $1;}')". Did you supply the parameters for this build?"
               fi
   ;;
steam-constructor) curl --silent --user bot:f23a8e133d4f4e713a53987d1a28c687 "http://jenkins.redpointlabs.com:8080/jenkins/view/BLOODREALM_STEAM/job/STEAM_CONSTRUCTOR/build"
               if [[ "$?" == "0" ]]; then
                 echo "Building Constructor.swf needed for steam client...."
                 echo "with VERSION: "${PARAM1}" and CHANGELOG: "${PARAM2}""
                else
                 echo "uh, uh. Something went wrong "$(echo $SKYPE_FULLNAME | awk '{print $1;}')". Did you supply the parameters for this build?"
               fi
   ;;
steam-uploader) curl --silent --user bot:f23a8e133d4f4e713a53987d1a28c687 "http://jenkins.redpointlabs.com:8080/jenkins/view/BLOODREALM_STEAM/job/STEAM_UPLOADER/build"
               if [[ "$?" == "0" ]]; then
                 echo "Uploading bloodrealm depots to Steamworks...."
                else
                 echo "uh, uh. Something went wrong "$(echo $SKYPE_FULLNAME | awk '{print $1;}')". Did you supply the parameters for this build?"
               fi
   ;;
web-version) curl --silent --user bot:f23a "http:///BLOOD_GAMEVERSION_WEB/build"
               if [[ "$?" == "0" ]]; then
                 echo "Updating game.version...."
                else
                 echo "uh, uh. Something went wrong "$(echo $SKYPE_FULLNAME | awk '{print $1;}')". Did you supply the parameters for this build?"
               fi
   ;;
android-version) curl --silent --user bot:f23 "http://ODREALM_ANDROID/job/BLOOD_GAMEVERSION_ANDROID/build"
               if [[ "$?" == "0" ]]; then
                 echo "Updating game.version...."
                else
                 echo "uh, uh. Something went wrong "$(echo $SKYPE_FULLNAME | awk '{print $1;}')". Did you supply the parameters for this build?"
               fi
   ;;
*) echo 'I dont know how to build that! :( Type "!build $JOBNAME" and I will build it.;)'
   echo 'type "!build list" to get a list of the jobs that I learned to build.'
   ;;
esac
