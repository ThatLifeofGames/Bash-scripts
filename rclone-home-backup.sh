#!/bin/bash
 # SOME FOLDER NAMES ARE REMOVED FOR GITHUB!
########################################
# Backup script to google drive account#
######################################## 

echo [SCRIPT LOG] Starting backup script at $(date) >> /root/backup.log

/usr/bin/rclone sync /Main/???/ gbackup:/???/\
 --fast-list \
 --drive-stop-on-upload-limit \
 --transfers 8 \
 --create-empty-src-dirs \
 --retries 50 \
 --config /root/.config/rclone/rclone.conf \
 --backup-dir gbackup:/Old/???/$(date +%G)/$(date +%m)/ \
 --suffix $(date +"__%d_%H:%M:%S") \
 --size-only \
 --suffix-keep-extension \
 --retries-sleep 30s >> /root/backup.log

echo [SCRIPT LOG] Finished syncing ??? folder at $(date) >> /root/backup.log

/usr/bin/rclone sync /Main/???/ gbackup:/???/ \
 --fast-list \
 --drive-stop-on-upload-limit \
 --transfers 1 \
 --retries 50 \
 --create-empty-src-dirs \
 --config /root/.config/rclone/rclone.conf \
 --backup-dir gbackup:/Old/???/$(date +%G)/$(date +%m)/ \
 --suffix $(date +"__%d_%H:%M:%S") \
 --suffix-keep-extension \ 
 --retries-sleep 30s \
 --size-only \
 --progress >> /root/backup.log 

echo [SCRIPT LOG] Finished syncing ??? at $(date). Done, exiting. >> /root/backup.log
