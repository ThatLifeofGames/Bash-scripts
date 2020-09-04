#!/bin/bash
############################################################################################
# Creates a database backup of mongodb (for xenon), and sends the data to an rclone remote #
# Backups are kept for 30 days, older backups are deleted then overwritten                 #
# Requires tar and a configured rclone remote                                              #
############################################################################################

# Create required DIRs, ignore messages about already existing
/bin/mkdir /data/backup-tmp > /dev/null
/bin/mkdir /data/backup-tmp/xenon > /dev/null
/bin/mkdir /data/backup-tmp/xenon/dump > /dev/null
/bin/mkdir /data/backup-tmp/xenon/upload > /dev/null

# Dump data to disk with lots of space, this may take a while
/usr/bin/mongodump --out=/data/backup-tmp/xenon/dump

# tar.gz data
/bin/tar -cvzf /data/backup-tmp/xenon/upload/backup.tar.gz /data/backup-tmp/xenon/dump

# Upload and overwrite old backup data
/usr/bin/rclone delete xenon:/Xenon-MongoDB/$(date +%d) --drive-use-trash=false --config /root/.config/rclone/rclone.conf > /dev/null
/usr/bin/rclone move /data/backup-tmp/xenon/upload xenon:/Xenon-MongoDB/$(date +%d) --drive-chunk-size 64M --bwlimit 75M --drive-use-trash=false --config /root/.config/rclone/rclone.conf > /dev/null # Transfer backup limited to 75MB/s as this server can be busy

# Cleanup

/bin/rm -rf /data/backup-tmp/xenon/*
