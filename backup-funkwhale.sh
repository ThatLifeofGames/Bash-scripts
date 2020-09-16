#!/bin/bash

##############################################################################################
# Funkwhale database, music (sync) and configuration file backup                             #
# Crontab entry:                                                                             #
# 0 3 * * * flock -n /var/lock/funkwhaleBackup.lock -c 'sh /root/backup-funkwhale.sh'        #
##############################################################################################

# Create directory and log to /dev/null in case it complains it exists

mkdir /tmp/funkwhale-backup > /dev/null

# Dump postgres datbase data for funkwhale and copy database backup to vps backups remote

sudo -u postgres -H pg_dump funkwhale > /tmp/funkwhale-backup/funkwhale_db_`date +%d-%m-%Y"_"%H_%M_%S`.sql
rclone move /tmp/funkwhale-backup/ vps-backups:/Hetzner/Funkwhale/Database --retries 50 --config /root/.config/rclone/rclone.conf

# Sync config file and move old versions to /Old folder

rclone sync /srv/funkwhale/config/.env vps-backups:/Hetzner/Funkwhale/Config --backup-dir vps-backups:/Hetzner/Funkwhale/Old/Configs/$(date +%G)/$(date +%m)/ --suffix $(date +"__%d_%H:%M:%S") --suffix-keep-extension --retries 50 --config /root/.config/rclone/rclone.conf

# Sync music/music artwork to vps backups remote keeping old versions in /Old folder

rclone sync /srv/funkwhale/data/media vps-backups:/Hetzner/Funkwhale/media --backup-dir vps-backups:/Hetzner/Funkwhale/Old/Media/$(date +%G)/$(date +%m)/ --suffix $(date +"__%d_%H:%M:%S") --suffix-keep-extension --create-empty-src-dirs --drive-stop-on-upload-limit --config /root/.config/rclone/rclone.conf --transfers 8
rclone sync /srv/funkwhale/data/music vps-backups:/Hetzner/Funkwhale/music --backup-dir vps-backups:/Hetzner/Funkwhale/Old/Music/$(date +%G)/$(date +%m)/ --suffix $(date +"__%d_%H:%M:%S") --suffix-keep-extension --create-empty-src-dirs --drive-stop-on-upload-limit --config /root/.config/rclone/rclone.conf --transfers 8

rm -rf /tmp/funkwhale-backup/
