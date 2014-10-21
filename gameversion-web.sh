#!/bin/bash

# used to auto commit a newer game version

REPO_URL='svn://svn02.dasdasdasdasds/game'  # the repo where game.properties will be obtained
GAME_PROPERTIES='game.properties'   # the path to game.properties file

function get_game_version {

 GAME_VERSION=$( grep 'game.version =' $GAME_PROPERTIES | cut -d '=' -f2 | tr -d ' ')

}

echo "pwd is ${PWD}"
rm -f $GAME_PROPERTIES
echo "checking out ${GAME_PROPERTIES}..." && svn co --username gonzalo --password redpoint333 ${REPO_URL} > /dev/null  && echo "game.properties was obtained successfully"
cd game

get_game_version

echo "Current game version is $GAME_VERSION"

NEW_VERSION="$( echo $GAME_VERSION | cut -d '.' -f1,2).$(( $( echo $GAME_VERSION | cut -d '.' -f3 | tr -cd '[:digit:]') + 1))"

echo "New game version will be $NEW_VERSION"

# now modify the version infile

sed -i  "s/game.version =.*/game.version = $NEW_VERSION/g" $GAME_PROPERTIES 

# commit the file back to svn 

svn commit -m 'new game version' --username gonzsdassa --password rasdasdas $GAME_PROPERTIES
