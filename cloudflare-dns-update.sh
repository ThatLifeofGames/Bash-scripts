#!/bin/bash
# Get all DNS info with curl -X GET "https://api.cloudflare.com/client/v4/zones/$zoneID/dns_records" -H "X-Auth-Email: $email" -H "X-Auth-Key: $key" -H "Content-Type: application/json" 

# Required details
email=""
key=""
zoneID=""
record=""
dnsID="" 

# Get current IP
ip=$(curl -s -X GET https://checkip.amazonaws.com)

# Update record
curl -X PUT "https://api.cloudflare.com/client/v4/zones/$zoneID/dns_records/$dnsID" \
     -H "X-Auth-Email: $email" \
     -H "X-Auth-Key: $key" \
     -H "Content-Type: application/json" \
     --data "{\"type\":\"A\",\"name\":\"$record\",\"content\":\"$ip\",\"ttl\":1,\"proxied\":true}"
