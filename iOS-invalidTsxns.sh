#!/bin/bash

# extract report from logs
REPORT=$(zgrep -i 'User Id' catalina.out* | cut -d' ' -f3-5 | sort -k3 | uniq -c | sort -nr)
# get TOT
TOT=$(echo "$REPORT" | awk '{print $1;}' | paste -sd+ | bc)
# other vars
MAIL=$(which mail)
CCMAIL=gonzalo@redpointlabs.com
EMAIL=sysadmin@redpointlabs.com

$MAIL -s "Bloodrealm - iOS invalid purchases - Weekly Report" -c $CCMAIL $EMAIL<<EOF

#### iOS Production - Invalid Purchases #### 

These ones have been flagged as "invalid" and rejected by our servers:

TOTAL: $TOT

By User Id:
$REPORT

#### iOS Production - Invalid Purchases #### 

Thanks,
root

EOF
