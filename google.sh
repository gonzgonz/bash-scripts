#!/bin/bash

# googl shell script
# Script for quick Google search
# To use, type google then your search terms
#elinks "www.google.com/search?q=$*"

#another approach using curl and ajax api

curl -s --get --data-urlencode "q=$*" http://ajax.googleapis.com/ajax/services/search/web?v=1.0 | sed 's/"unescapedUrl":"\([^"]*\).*/\1/;s/.*GwebSearch",//' | sed 's/\\u003d/=/g'
