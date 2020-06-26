#!/bin/bash

##############################################################################################                                 
# Funkwhale database, music (sync) and configuration file backup                             #
# Crontab entry:                                                                             #
# 0 2 * * * flock -n /var/lock/funkwhaleBackup.lock -c 'sh /home/ubuntu/backup-funkwhale.sh' #
##############################################################################################

# Create directory and log to /dev/null in case it complains it exists

mkdir /tmp/funkwhale-backup > /dev/null

# Dump postgres datbase data for funkwhale and copy database backup to vps backups remote

sudo -u postgres -H pg_dump funkwhale > /tmp/funkwhale-backup/funkwhale_db_`date +%d-%m-%Y"_"%H_%M_%S`.sql
rclone move /tmp/funkwhale-backup/ vps-backups:/Funkwhale/Database --retries 50 --config /root/.config/rclone/rclone.conf

# Sync config file and move old versions to /Old folder

rclone sync /srv/funkwhale/config/.env vps-backups:/Funkwhale/Config --backup-dir vps-backups:/Funkwhale/Old/Configs/$(date +%G)/$(date +%m)/ --suffix $(date +"__%d_%H:%M:%S") --suffix-keep-extension --retries 50 --config /root/.config/rclone/rclone.conf

# Sync nginx configs

rclone sync /etc/nginx/sites-enabled/ vps-backups:/Funkwhale/Nginx --backup-dir vps-backups:/Funkwhale/Old/Nginx/$(date +%G)/$(date +%m)/ --suffix $(date +"__%d_%H:%M:%S") --suffix-keep-extension --create-empty-src-dirs --retries 50 --config /root/.config/rclone/rclone.conf --copy-links

# Sync music/music artwork to vps backups remote keeping old versions in /Old folder

rclone sync /srv/funkwhale/data/media vps-backups:/Funkwhale/media --backup-dir vps-backups:/Funkwhale/Old/Media/$(date +%G)/$(date +%m)/ --suffix $(date +"__%d_%H:%M:%S") --suffix-keep-extension --create-empty-src-dirs --drive-stop-on-upload-limit --config /root/.config/rclone/rclone.conf
rclone sync /srv/funkwhale/data/music vps-backups:/Funkwhale/music --backup-dir vps-backups:/Funkwhale/Old/Music/$(date +%G)/$(date +%m)/ --suffix $(date +"__%d_%H:%M:%S") --suffix-keep-extension --create-empty-src-dirs --drive-stop-on-upload-limit --config /root/.config/rclone/rclone.conf
