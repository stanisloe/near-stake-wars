Here you can find 2 scripts: backup and restore backup
First one will stop neard process, copy and archive data folder, move it to backup folder and start neard again.
It will perform daily, weekly and monthly backups. You can run it on a daily basis. It will also remove old backups automatically.
Also make sure to pass your health check id to monitor health of your cron.

To restore from a backup simply pass your backup file full path and near working dir to restore_backup.sh
