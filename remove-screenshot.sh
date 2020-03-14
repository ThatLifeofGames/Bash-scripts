#!/bin/bash

clear
echo 'Which screenshot should be deleted?'

read removeImg

if rm /var/www/chris.land/html/i/$removeImg* ; then
        clear
        echo "Success, check https://chris.land/i/$removeImg for cloudflare cache persistence and remove at https://dash.cloudflare.com/0dad1f233bc5b34886f2174ee3927246/chris.land/caching. Don't forget to remove from backups if needed"
else
        echo "Error while deleting"
fi

sleep 30
exit
