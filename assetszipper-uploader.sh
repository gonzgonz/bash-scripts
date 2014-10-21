#!/bin/bash

# this one is used together with a Jenkins task. When Jenkins detects changes in repository, performs svn update and downloads changes to working copy,
# then we zip only folder who contain changes, and upload them to S3

# INITIAL SETUP OF ENVIRONMENT
ASSETS_DIR="$1"
S3BUCKET="$2"
S3CMD=$(which s3cmd)

if [ "$#" == "0" ]; then
    echo "You must provide the path as an argument"
    exit 1
fi

cd ${ASSETS_DIR}

echo "working on ${PWD}"

#### START ZIPPING   #####
echo "Packing all subfolders with changes in ${ASSETS_DIR}"

MFOLDERS=$(find . -type d -mmin -5 | grep -v '.svn' | tr -d './')
for folder in ${MFOLDERS}; do zip -j -r $folder $folder ; done
if [ $? -ne 0 ]; then
 echo "There was an error, please check the arguments given and the path/s"
 exit 1
else
 echo "Zips were created successfully"
fi

#### UPLOAD TO S3 BUCKET ####
"${S3CMD}" --progress -v sync *.zip "${S3BUCKET}"

if [ $? -ne 0 ]; then
 echo "There was an error in the sync to S3... Please check."
 exit 1
else
 echo "Successfully synced zipped assets to "${S3BUCKET}""
fi
