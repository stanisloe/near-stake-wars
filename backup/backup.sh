#!/bin/bash

CURRENT_DATE=$(date +%Y-%m-%d)
CURRENT_WEEK=$(date +%Y-%m-%d-%w)
CURRENT_MONTH=$(date +%Y-%m)

printf "Current date: $CURRENT_DATE\nCurrent week: $CURRENT_WEEK\nCurrent month: $CURRENT_MONTH\n"

HEALTH_CHECK_ID=$1
DATA_DIR=$2
BACKUP_DIR=$3

if [ -z "$HEALTH_CHECK_ID" ]; then echo "health check id not set" && exit 1; fi
if [ -z "$DATA_DIR" ]; then DATA_DIR="/root/.near"; fi
if [ -z "$BACKUP_DIR" ]; then BACKUP_DIR="/root/backup"; fi

echo "setting data dir to $DATA_DIR"
echo "setting backup dir to $BACKUP_DIR"

systemctl stop neard.service
wait

echo "NEAR node was stopped"

daily_backup="$BACKUP_DIR/$CURRENT_DATE.gz"
weekly_backup="$BACKUP_DIR/$CURRENT_WEEK.gz"
monthly_backup="$BACKUP_DIR/$CURRENT_MONTH.gz"

if [ ! -f $daily_backup ]; then
    tar -cjf $daily_backup -C "$DATA_DIR/" data;
fi

if [ ! -f $weekly_backup ]; then
    cp $daily_backup $weekly_backup
fi

if [ ! -f $monthly_backup ]; then
    cp $daily_backup $monthly_backup
fi

# remove old backup files
for filename in $BACKUP_DIR/*.gz; do
    if [ ! -z "${daily_backup##*$filename*}" -a ! -z "${weekly_backup##*$filename*}" -a ! -z "${monthly_backup##*$filename*}" ] ;then
        echo "Removing $filename"
        rm $filename
    fi
done

systemctl start neard.service

echo "NEAR node was started"

/usr/bin/curl -fsS -m 10 --retry 5 -o /dev/null "https://hc-ping.com/$HEALTH_CHECK_ID"
