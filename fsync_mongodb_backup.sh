#!/bin/bash

set -x

EMAIL=sysadmin@redpointlabs.com
TAR=`which tar`
MONGO_LOG=/var/log/mongo/mongod-backup.log
MONGO_SNAP_LOG=/var/log/mongo/mongo-snap.log

MONGODB_SHELL='/usr/bin/mongo'

DUMP_UTILITY='/usr/bin/mongodump'
DB_NAME="$1"

date_now=`date +%Y_%m_%d_%H_%M_%S`
dir_name='/mnt/backups/mongodb/backup_'${date_now}
file_name='/mnt/backups/mongodb/backup_'${date_now}'.tar.gz'

# Rotate backups older than 7 days
find /mnt/backups/mongodb/ -mtime +7 -type f -exec rm -f {} \;

# Check if $DBNAME actually exists
while read line
do
        if [ ${line} == ${DB_NAME} ]; then
                EXIST=1
                break
        else
                EXIST=0
        fi
done < <(echo "show dbs" | /usr/bin/mongo | awk '{ print $1 }')

if [ $EXIST -ne 1 ]; then
        mail -s "MF hidden3 $DB_NAME MongoDB Backup FAILED" $EMAIL<<EOF

Mongo Database $DB_NAME does not exist on `hostname`
EOF
exit 1
fi

rm -f $MONGO_LOG $MONGO_SNAP_LOG
touch $MONGO_LOG
touch $MONGO_SNAP_LOG

log() {
    echo $1
}

do_cleanup(){
    rm -rf ${dir_name}
    log 'cleaning up....'
}

do_lock_db(){
    echo 'fsyncLock()' | mongo admin 
    log 'locking mongodb....'
}

do_unlock_db(){
   echo 'fsyncUnlock()' | mongo admin
   log 'unlocking mongodb....'
}

do_backup(){
    log 'snapshotting the db and creating archive' && \
    ${DUMP_UTILITY} -d ${DB_NAME} -o ${dir_name} 2>&1 | tee -a $MONGO_SNAP_LOG && $TAR -zcf $file_name ${dir_name} 2>&1 | tee -a $MONGO_SNAP_LOG
    ${MONGODB_SHELL} admin /usr/local/bin/unlock.js && \
    log 'data backed up and created snapshot'
}

send_email_failed() {
        mail -s "MF Dominion MongoDB $DB_NAME DB backup FAILED" $EMAIL<<EOF

`cat $MONGO_LOG`

===============

`cat $MONGO_SNAP_LOG`

Cheers,
root
EOF
}

send_email_ok() {
        mail -s "MF Dominion MongoDB $DB_NAME DB backup OK" $EMAIL<<EOF

`cat $MONGO_LOG`

`cat $MONGO_SNAP_LOG`

EOF
}

do_lock_db && do_backup && do_unlock_db && do_cleanup && send_email_ok || send_email_failed
