#!/bin/bash
#
# ORIGINAL
# https://gist.github.com/Tras2/cba88201b17d765ec065ccbedfb16d9a
#
if [[ -z $ZONE ]]; then
  echo "\$ZONE must be specified (e.g. ZONE=example.com)"
  exit 1
fi
if [[ -z $DNSRECORD ]]; then
  echo "\$DNSRECORD must be specified (e.g. DNSRECORD=www.example.com)"
  exit 1
fi
if [[ -z $AUTH_EMAIL ]]; then
  echo "\$AUTH_EMAIL must be specified (e.g. AUTH_EMAIL=johndoe@example.com)"
  exit 1
fi
if [[ -z $AUTH_KEY ]]; then
  echo "\$AUTH_KEY must be specified (e.g. AUTH_KEY=...)"
  exit 1
fi
API="https://api.cloudflare.com/client/v4"
req() {
  curl \
    -X "Content-Type: application/json" \
    -X "X-Auth-Email: $AUTH_EMAIL" \
    -X "X-Auth-Key: $AUTH_KEY" \
    $@
}

# Get the current external IP address
ip=$(curl -s https://checkip.amazonaws.com)

echo "Current IP is $ip"

if host $DNSRECORD 1.1.1.1 | grep "has address" | grep "$ip"; then
  echo "$DNSRECORD is currently set to $ip; no changes needed"
  exit
fi

# get the zone id for the requested zone
zoneid=$(curl -s "https://api.cloudflare.com/client/v4/zones?name=$ZONE&status=active" \
  -H "X-Auth-Email: $AUTH_EMAIL" \
  -H "X-Auth-Key: $AUTH_KEY" \
  -H "Content-Type: application/json" | jq -r '{"result"}[] | .[0] | .id')

echo "Zoneid for $ZONE is $zoneid"

# get the dns record id
dnsrecordid=$(curl -s "https://api.cloudflare.com/client/v4/zones/$zoneid/dns_records?type=A&name=$DNSRECORD" \
  -H "X-Auth-Email: $AUTH_EMAIL" \
  -H "X-Auth-Key: $AUTH_KEY" \
  -H "Content-Type: application/json" | jq -r '{"result"}[] | .[0] | .id')

echo "DNSrecordid for $DNSRECORD is $dnsrecordid"

# update the record
curl -s -X PATCH "https://api.cloudflare.com/client/v4/zones/$zoneid/dns_records/$dnsrecordid" \
  -H "X-Auth-Email: $AUTH_EMAIL" \
  -H "X-Auth-Key: $AUTH_KEY" \
  -H "Content-Type: application/json" \
  --data "{\"content\":\"$ip\"}" | jq
