#!/bin/sh
# Forked from https://github.com/oznu/docker-cloudflare-ddns
. /app/cloudflare.sh
. /tmp/cloudflare.conf

set -e

ipCur=$(getPublicIpAddress)
ipDns=$(getDnsRecordIp $CF_ZONE_ID $CR_RECORD_ID)

if [ "$ipCur" == "$ipDns" ]; then
  echo "No DNS update required for $CF_RECORD_NAME ($ipDns)"
  exit
fi

echo "Updating CloudFlare DNS record $CF_RECORD_NAME from $ipDns to $ipCur..."
result=$(updateDnsRecord $CF_ZONE_ID $CF_RECORD_ID $CF_RECORD_NAME $ipCur)

if [ "$result" == "null" ]; then
  echo "ERROR: Failed to update CloudFlare DNS record $CF_RECORD_NAME from $ipDns to $ipCur"
else
  echo "CloudFlare DNS record $CF_RECORD_NAME ($ipCur) updated successfully."
fi
