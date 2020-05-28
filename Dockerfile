FROM alpine:latest
MAINTAINER lambdalisue <lambdalisue@hashnote.net>

RUN apk add --no-cache curl jq bind-tools
COPY ./docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/bin/sh", "docker-entrypoint.sh"]
