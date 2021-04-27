#!/bin/bash

##############################################################################################
# Funkwhale database, music (sync) and configuration file backup                             #
# Crontab entry:                                                                             #
# 0 3 * * * flock -n /var/lock/funkwhaleBackup.lock -c 'sh /root/backup-funkwhale.sh'        #
##############################################################################################

# Create directory and log to /dev/null in case it complains it exists

mkdir /tmp/funkwhale-backup > /dev/null

# Dump postgres datbase data for funkwhale and copy database backup to server backups remote

sudo -u postgres -H pg_dump funkwhale > /tmp/funkwhale-backup/funkwhale_db_`date +%d-%m-%Y"_"%H_%M_%S`.sql # Dump the database
rclone delete server-backups:/Hetzner/Funkwhale/Database/$(date +%d) --drive-use-trash=false # Delete the previous 30 day old backup
rclone move /tmp/funkwhale-backup/ server-backups:/Hetzner/Funkwhale/Database/$(date +%d) --retries 50 --config /root/.config/rclone/rclone.conf # Move the new backup

# Sync config file and move old versions to /Old folder

rclone delete server-backups:/Hetzner/Funkwhale/Old/Configs/$(date +%d)/ --drive-use-trash=false # Delete anything removed over a month ago
rclone sync /srv/funkwhale/config/.env server-backups:/Hetzner/Funkwhale/Config --backup-dir server-backups:/Hetzner/Funkwhale/Old/Configs/$(date +%d)/ --retries 50 --config /root/.config/rclone/rclone.conf

# Sync music/music artwork to server backups remote keeping old versions in /Old folder

# Delete anything removed over a month ago
rclone delete server-backups:/Hetzner/Funkwhale/Old/Media/$(date +%d)/ --drive-use-trash=false
rclone delete server-backups:/Hetzner/Funkwhale/Old/Music/$(date +%d)/ --drive-use-trash=false

# Sync changes, move removed files 
rclone sync /srv/funkwhale/data/media server-backups:/Hetzner/Funkwhale/media --backup-dir server-backups:/Hetzner/Funkwhale/Old/Media/$(date +%d)/ --create-empty-src-dirs --drive-stop-on-upload-limit --config /root/.config/rclone/rclone.conf --transfers 8
rclone sync /srv/funkwhale/data/music server-backups:/Hetzner/Funkwhale/music --backup-dir server-backups:/Hetzner/Funkwhale/Old/Music/$(date +%d)/ --create-empty-src-dirs --drive-stop-on-upload-limit --config /root/.config/rclone/rclone.conf --transfers 8

rm -rf /tmp/funkwhale-backup/
