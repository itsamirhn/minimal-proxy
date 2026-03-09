#!/bin/sh
echo "tproxy: listening on :${LISTEN_PORT}, forwarding to ${UPSTREAM_HOST}:${UPSTREAM_PORT}"
exec socat TCP-LISTEN:${LISTEN_PORT},fork,reuseaddr TCP:${UPSTREAM_HOST}:${UPSTREAM_PORT}
