#!/bin/sh
echo "bridge: listening on :${LISTEN_PORT}, forwarding to ${UPSTREAM_HOST}:${UPSTREAM_PORT}"
exec tproxy -l 0.0.0.0 -p ${LISTEN_PORT} -r ${UPSTREAM_HOST}:${UPSTREAM_PORT} -s
