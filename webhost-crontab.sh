@weekly tar -zcf "/tmp/sites.tgz" /var/www; rclone move /tmp/sites.tgz "backups:/Webhost" --config /home/ubuntu/.config/rclone/rclone.conf
@daily tar -zcf "/tmp/home.tgz" /home; rclone move /tmp/home.tgz "backups:/Webhost" --config /home/ubuntu/.config/rclone/rclone.conf
@daily docker images |grep -v REPOSITORY|awk '{print $1}'|xargs -L1 docker pull && docker image prune -f
@hourly flock -n /var/lock/websync.lock -c 'rclone sync /var/www/ backups:/Webhost/Sync --config /home/ubuntu/.config/rclone/rclone.conf'
