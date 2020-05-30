FROM alpine:latest
MAINTAINER lambdalisue <lambdalisue@hashnote.net>

RUN apk add --no-cache curl jq bind-tools

COPY ./assets/ /
CMD /bin/sh /docker-entrypoint.sh
