#!/bin/bash
###############################################
# Syncs webserver data to "hot spare" server  #
###############################################

# Wait for main web server to (hopefully) finish hourly sync
sleep 90

# Sync SSL files
/bin/rclone sync vps-backups:/Webserver/SSL /etc/nginx/ssl --config /root/.config/rclone/rclone.conf >> /home/chris/sync.log

# Sync config files
/bin/rclone sync vps-backups:/Webserver/Config /etc/nginx/sites-enabled --config /root/.config/rclone/rclone.conf >> /home/chris/sync.log

# Sync web data
/bin/rclone sync vps-backups:/Webserver/Web /var/www --config /root/.config/rclone/rclone.conf >> /home/chris/sync.log

# Reload NGINX to apply any config changes
/bin/systemctl reload nginx.service
