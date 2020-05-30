FROM alpine:latest
MAINTAINER lambdalisue <lambdalisue@hashnote.net>

RUN apk add --no-cache curl jq bind-tools

COPY ./docker-entrypoint.sh /docker-entrypoint.sh
COPY ./assets/crontab.template /crontab.template
COPY ./assets/update-cloudflare-ddns.sh /update-cloudflare-dns.sh

CMD /bin/sh /docker-entrypoint.sh
