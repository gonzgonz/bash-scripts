###################################
#
# © RedPoint Labs S.A.
#
# This script gets zipped xcarchive from last successful Release build and uploads it to dropbox together with the ipa
#
# Current version 0.5 - Gonzalo Arce
#
###################################


#!/bin/bash

PROJECT_NAME="BloodRealm"  # App name here
DATE="$(date +%Y%m%d)"
IPA_DIR="${HOME}/Desktop/Releases"  # folder to drop ipa files
EMAIL="alerts@redpointlabs.com"
SENDMAIL="/Users/rpladmin/Desktop/sendhtml.sh"
SUBJECT="iOS Latest Release Dropbox Link"
DROPBOX_DIR="2Dropbox"  ## the name of the folder that has the last release and zipped xcarchive (the whole folder will be uploaded)
DROPBOX='/jenkins/dropbox_uploader.sh'   ### the path to the dropbox-uploader script
EMAIL="/tmp/dpmail${DATE}.txt"
RECIPIENTS='gonzalo@redpointlabs.com'              # addresses to notify

######## End Variables


echo "working on path:"
echo "${IPA_DIR}"
cd "${IPA_DIR}"

# Upload latest release to Dropbox

echo 'Uploading to dropbox... please wait (takes a few minutes to complete)'
"${DROPBOX}" -p upload "${DROPBOX_DIR}" 

# Check if upload succeeded
if [ $? != 0 ]
then
  exit 1
fi

echo 'Uploaded to dropbox successully!!'

# Share the upload and notify by email

echo 'Sharing the folder....'
echo 'Latest iOS release was succesfully uploaded to dropbox, you can find it in the following link:' > "${EMAIL}"

"${DROPBOX}" share "${DROPBOX_DIR}" | tee -a "${EMAIL}"

echo 'Sending email notification...'
"${SENDMAIL}" "${SUBJECT}" "${RECIPIENTS}" "${EMAIL}"

# Check if sending email succeded
if [ $? != 0 ]
then
  exit 1
fi


echo "Email was sent to "${RECIPIENTS}" successfully."


# Rotate Dropbox releases inside the account (this one is tricky :P)

echo 'Rotating dropbox releases on the account...'

# get the file names for the oldest release (an ipa and an xcarhive.zip)
OLDEST_RELEASE="$("${DROPBOX}" list "${DROPBOX_DIR}" | tail +2 | tr -d '[F]' | head -2)"

# count how many releases we have stored
RELEASE_COUNT="$("${DROPBOX}" list "${DROPBOX_DIR}" | grep -c ipa)"
while [ "${RELEASE_COUNT}" -gt "5" ]
do
 for file in ${OLDEST_RELEASE}; do "${DROPBOX}" delete "${DROPBOX_DIR}"/$file; done
 RELEASE_COUNT="$("${DROPBOX}" list "${DROPBOX_DIR}" | grep -c ipa)"
done

# Check if rotation succeeded
if [ $? != 0 ]
then
  echo 'WARNING: There were errors while trying to rotate the files inside the dropbox account, please check!'
fi
echo 'Dropbox releases were rotated successfully.'

echo "-----------------------------------------------"
echo "${PROJECT_NAME} Succesfully uploaded and shared to Dropbox."
#echo "-----------------------------------------------"
#echo "Manual download link  ( http://${LOCAL_SERVER}/downloads/${VERSION}.ipa )"
