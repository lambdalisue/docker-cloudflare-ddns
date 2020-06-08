FROM alpine:latest
MAINTAINER lambdalisue <lambdalisue@hashnote.net>

RUN apk add --no-cache curl jq bind-tools
RUN echo "1.1.1.1" > /etc/resolv.conf

COPY ./assets/ /
CMD /bin/sh /docker-entrypoint.sh
