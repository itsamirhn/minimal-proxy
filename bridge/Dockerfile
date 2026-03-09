FROM alpine:latest

RUN apk add --no-cache socat

ENV UPSTREAM_HOST=server
ENV UPSTREAM_PORT=443
ENV LISTEN_PORT=443

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
