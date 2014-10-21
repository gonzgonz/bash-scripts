#!/bin/bash

# Simple script for zipping the contents of all subdirectories on a given path

# The full path to the main dir
ASSETS_DIR="$1"

if [ "$#" == "0" ]; then
    echo "You must provide the path as an argument"
    exit 1
fi

cd $ASSETS_DIR

echo "working on $PWD"
echo "Zipping the contents of all subdirectories inside of $ASSETS_DIR"

for subdir in $(ls -d */ | tr -d '/'); do zip -j -r $subdir $subdir ; done

if [ $? -ne 0 ]; then
 echo "There was an error, please check the arguments given and the path/s"
 exit 1
else
 echo "Zips were created successfully"
fi
