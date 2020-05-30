#!/bin/sh
. /app/cloudflare.sh

set -e

# Verify $API_KEY
statusCode=$(verifyToken)

if [ "$statusCode" != "200" ]; then
  echo "-----------------------------------------------------------------"
  echo "ERROR: Invalid CloudFlare Credentials - $statusCode"
  echo "-----------------------------------------------------------------"
  exit 1
fi

# Get CloudFlare Zone ID
CFZoneId=$(getZoneId)
if [ "$CFZoneId" == "null" ]; then
  echo "-----------------------------------------------------------------"
  echo "ERROR: Zone for $ZONE was not found in your CloudFlare account"
  echo "-----------------------------------------------------------------"
  exit 1
fi
echo "DNS Zone: $ZONE ($CFZoneId)"

# Get CloudFlare DNS record ID
CFDnsRecordName=$(getDnsRecordName)
CFDnsRecordId=$(getDnsRecordId $CFZoneId $CFDnsRecordName)
if [ "$CFDnsRecordId" == "null" ]; then
  echo "-----------------------------------------------------------------"
  echo "ERROR: DNS record '$CFDnsRecordName' was not found in $ZONE"
  echo "-----------------------------------------------------------------"
  exit 1
fi
echo "DNS Record: $CFDnsRecordName ($CFDnsRecordId)"

# Save retrived data in cache file
echo "" > /tmp/cloudflare.conf
echo "CF_ZONE_ID=\"$CFZoneId\"" >> /tmp/cloudflare.conf
echo "CF_RECORD_ID=\"$CFDnsRecordId\"" >> /tmp/cloudflare.conf
echo "CF_RECORD_NAME=\"$CFDnsRecordName\"" >> /tmp/cloudflare.conf

# Create a new crontab file from skeleton
if [ -z "$SCHEDULE" ]; then
  SCHEDULE="*/10 * * * *"
fi
echo "$SCHEDULE /bin/sh /ddns.sh" > /var/spool/cron/crontabs/root

# Execute ddns.sh immediately
/bin/sh /ddns.sh

# Start crontab
crond -f

