#!/bin/bash

echo 'Which screenshot should be deleted?'

read removeImg

if rm /var/www/chris.land/html/i/$removeImg* ; then
        echo "Success, check https://chris.land/i/$removeImg for cloudflare cache persistence and remove from backups if needed"
else
        echo "Error while deleting"
fi

sleep 30
exit
