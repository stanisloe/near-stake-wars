#!/bin/sh

export NEAR_ENV=shardnet
export LOGS=/root/logs
export NEAR_ACCOUNT_ALIAS=%alias%

echo "---" >> $LOGS/all.log
date >> $LOGS/all.log
near call $NEAR_ACCOUNT_ALIAS.factory.shardnet.near ping '{}' --accountId $NEAR_ACCOUNT_ALIAS.shardnet.near >> $LOGS/all.log
near proposals | grep $NEAR_ACCOUNT_ALIAS >> $LOGS/all.log
near validators current | grep $NEAR_ACCOUNT_ALIAS >> $LOGS/all.log
near validators next | grep $NEAR_ACCOUNT_ALIAS >> $LOGS/all.log
