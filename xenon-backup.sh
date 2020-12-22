#!/bin/bash
############################################################################################
# Creates a database backup of mongodb (for xenon), and sends the data to an rclone remote #
# Backups are kept for 30 days, older backups are deleted                                  #
# Requires MongoDump, rclone remote and credentials added                                  #
############################################################################################

# Delete old data

/usr/bin/rclone delete xenon:/Xenon-MongoDB/$(date +%d) --drive-use-trash=false --config /root/.config/rclone/rclone.conf >/dev/null 2>&1

# Dump and upload data via stdout and gzip + archive while uploading

/usr/bin/mongodump --archive --gzip --host 10.0.0.2 --port 27017 | /usr/bin/rclone rcat xenon:/Xenon-MongoDB/$(date +%d)/Dump.archive --drive-chunk-size 64M --bwlimit 30M --drive-use-trash=false --config /root/.config/rclone/rclone.conf >/dev/null 2>&1
