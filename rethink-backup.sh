#!/bin/bash

cd /tmp/rethink && rethinkdb dump --file "Rethinkdb Backup $(date +\%F).tar.gz" && && sudo rclone move /tmp/rethink backups:/Databases/Vega --config /home/chris/.config/rclone/rclone.conf
