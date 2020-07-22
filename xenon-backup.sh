#!/bin/bash
############################################################################################
# Creates a database backup of mongodb (for xenon), and sends the data to an rclone remote #
# Backups are kept for 30 days, older backups are deleted then overwritten                 #
# Requires tar and a configured rclone remote                                              #
############################################################################################

# At the time of this commit, this script is UNTESTED

# Create required DIRs, ignore messages about already existing
/bin/mkdir /data/backup-tmp > /dev/null
/bin/mkdir /data/backup-tmp/xenon > /dev/null
/bin/mkdir /data/backup-tmp/xenon/dump > /dev/null
/bin/mkdir /data/backup-tmp/xenon/upload > /dev/null

# Dump data to disk with lots of space, this may take a while
/usr/bin/mongodump --out=/data/backup-tmp/xenon/dump

# tar.gz data in to 5gb chunks, reattach to a single archive and extract with cat backup.tar.gz.* | tar xzvf - 
/bin/tar cvzf - /data/backup-tmp/xenon/dump | /usr/bin/split --bytes=5GB - /data/backup-tmp/xenon/upload/backup.tar.gz.

# Upload and overwrite old backup data
/usr/bin/rclone delete xenon:/Xenon-MongoDB/$(date +%d) > /dev/null
/usr/bin/rclone move /data/backup-tmp/xenon/upload xenon:/Xenon-MongoDB/$(date +%d) --drive-chunk-size 64M --bwlimit 75M > /dev/null # Transfer backup limited to 75MB/s as this server can be busy

# Cleanup

/bin/rm -rf /data/backup-tmp/xenon/*
