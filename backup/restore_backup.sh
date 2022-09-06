#!/bin/bash

backup_file=$1
near_home=$2

systemctl stop neard.service
wait

mv $near_home/data $near_home/data_old/

tar -C $near_home -xvf $backup_file

systemctl start neard.service

echo "backup restored"
