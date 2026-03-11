#!/bin/sh
# S3 operations via curl with SOCKS5 proxy support
# Usage: s3.sh <command> [args...]
#   s3.sh ls                        - list objects in bucket
#   s3.sh get <key> <outfile>       - download object
#   s3.sh put <localfile> <key>     - upload object
#   s3.sh rm <key>                  - delete object

set -e
. /app/s3-env.sh

CURL_PROXY=""
if [ -n "$S3_PROXY" ]; then
  CURL_PROXY="--socks5-hostname $(echo "$S3_PROXY" | sed 's|socks5://||;s|socks5h://||')"
fi

s3_curl() {
  curl -sf $CURL_PROXY \
    --aws-sigv4 "aws:amz:us-east-1:s3" \
    --user "${S3_ACCESS_KEY}:${S3_SECRET_KEY}" \
    "$@"
}

case "$1" in
  ls)
    s3_curl "https://${S3_ENDPOINT}/${S3_BUCKET}/" \
      | sed 's|<Key>|\n|g' | sed -n 's|^\([^<]*\)</Key>.*|\1|p'
    ;;
  get)
    s3_curl "https://${S3_ENDPOINT}/${S3_BUCKET}/$2" -o "$3"
    ;;
  put)
    s3_curl "https://${S3_ENDPOINT}/${S3_BUCKET}/$3" \
      -T "$2" \
      -H "Content-Type: application/octet-stream"
    ;;
  rm)
    s3_curl "https://${S3_ENDPOINT}/${S3_BUCKET}/$2" -X DELETE
    ;;
  *)
    echo "Usage: s3.sh <ls|get|put|rm> [args...]"
    exit 1
    ;;
esac
