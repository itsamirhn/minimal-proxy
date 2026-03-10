FROM golang:alpine AS builder

RUN go install github.com/kevwan/tproxy@latest

FROM alpine:latest

COPY --from=builder /go/bin/tproxy /usr/local/bin/tproxy

ENV UPSTREAM_HOST=server
ENV UPSTREAM_PORT=443
ENV LISTEN_PORT=443

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
