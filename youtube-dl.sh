#!/bin/bash

rm -rf ./tmp

# Manual (individual videos) archival

youtube-dl \
--dateafter 20050101 \
--download-archive ./downloaded-manual.txt \
--batch-file ./manual.txt \
--no-overwrites \
--continue \
--ignore-errors \
--add-metadata \
--write-description \
--write-thumbnail \
--geo-bypass \
-o "/home/personal/yt-dl/tmp/Archive/%(title)s-%(upload_date)s" \
--exec 'rclone move /home/personal/yt-dl/tmp/ yt-dl:/ --progress --delete-empty-src-dirs --config /home/ubuntu/.config/rclone/rclone.conf && echo'

echo 'Finished manual, moving to music...'

# Music

youtube-dl \
--dateafter 20050101 \
--download-archive ./downloaded-music.txt \
--batch-file ./music.txt \
--no-overwrites \
--continue \
--ignore-errors \
--extract-audio \
--audio-quality 0 \
--geo-bypass \
-o "/home/personal/yt-dl/tmp/Music/%(playlist_title)s/%(title)s.%(ext)s" \
--exec 'rclone move /home/personal/yt-dl/tmp/ yt-dl:/ --progress --delete-empty-src-dirs --config /home/ubuntu/.config/rclone/rclone.conf && echo'

echo 'Finished music, moving to playlists...'

# Playlists

youtube-dl \
--dateafter 20050101 \
--download-archive ./downloaded-playlists.txt \
--batch-file ./playlists.txt \
--no-overwrites \
--continue \
--ignore-errors \
--add-metadata \
--write-description \
--write-thumbnail \
--geo-bypass \
-o "/home/personal/yt-dl/tmp/Playlists/%(playlist_title)s/%(title)s-%(uploader)s-%(upload_date)s.%(ext)s" \
--exec 'rclone move /home/personal/yt-dl/tmp/ yt-dl:/ --progress --delete-empty-src-dirs --config /home/ubuntu/.config/rclone/rclone.conf && echo'

echo 'Finished playlists, moving to channels...'

# Channels

youtube-dl \
--dateafter 20050101 \
--download-archive ./downloaded-channels.txt \
--batch-file ./channels.txt \
--no-overwrites \
--continue \
--ignore-errors \
--add-metadata \
--write-description \
--write-thumbnail \
--geo-bypass \
-o "/home/personal/yt-dl/tmp/Channels/%(uploader)s/%(title)s-%(upload_date)s.%(ext)s" \
--exec 'rclone move /home/personal/yt-dl/tmp/ yt-dl:/ --progress --delete-empty-src-dirs --config /home/ubuntu/.config/rclone/rclone.conf && echo'

echo "Finished channels... All done. Ended at $(date)"
