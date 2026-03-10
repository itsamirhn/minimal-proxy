#!/bin/sh
set -e

echo "$XRAY_CONFIG" > /etc/xray/config.json

echo "xbridge: config generated"
cat /etc/xray/config.json

exec xray run -c /etc/xray/config.json
