#!/bin/bash
# Forked from https://github.com/oznu/docker-cloudflare-ddns
CF_API=https://api.cloudflare.com/client/v4

cloudflare() {
  curl -sSL \
    -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $API_KEY" \
    "$@"
}

getPublicIpAddress() {
  curl -sf4 https://ipinfo.io | jq -r '.ip'
}

getDnsRecordName() {
  if [ -z "$SUBDOMAIN" ]; then
    echo $ZOME
  else
    echo $SUBDOMAIN.$ZONE
  fi
}

verifyToken() {
  cloudflare -o /dev/null -w "%{http_code}" "$CF_API/user/tokens/verify"
}

getZoneId() {
  cloudflare "$CF_API/zones?name=$ZONE" | jq -r '.result[0].id'
}

getDnsRecordId() {
  cloudflare "$CF_API/zones/$1/dns_records?type=A&name=$2" | jq -r '.result[0].id'
}

updateDnsRecord() {
  cloudflare -X PATCH \
    -d "{\"name\": \"$3\", \"content\": \"$4\"}" \
    "$CF_API/zones/$1/dns_records$2" | jq -r '.result.id'
}

getDnsRecordIp() {
  cloudflare "$CF_API/zones/$1/dns_records/$2" | jq -r '.result.content'
}
