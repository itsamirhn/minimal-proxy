#!/bin/sh
set -e

test -n "$VLESS_UUID" || { echo "VLESS_UUID env is required"; exit 1; }

sed -i "s/VLESS_UUID_PLACEHOLDER/$VLESS_UUID/" /etc/xray/config.json

exec xray run -c /etc/xray/config.json
