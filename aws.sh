#!/bin/bash

# example script by Gonzalo Arce: manipulate aws environments with sevabot, a python bot (not developed by me(

case $1 in

environments) aws elasticbeanstalk describe-environments --query 'Environments[*].[EnvironmentName]' --output text
          ;;
update) ENVIRONMENT=$2 ; VERSION=$3
        aws elasticbeanstalk update-environment --environment-name $ENVIRONMENT --version-label $VERSION 
     ;;
route53) aws route53 list-resource-record-sets --hosted-zone-id "/hostedzone/Z2Y1ZW6Q1SP54N" --output text --query 'ResourceRecordSets[*]'
     ;;
esac
