#!/bin/sh
set -e

TIMESTAMP=$(date -u +%Y-%m-%dT%H-%M-%S)
BACKUP_NAME="backup-${TIMESTAMP}.tar.gz"
BACKUP_PATH="/tmp/${BACKUP_NAME}"

echo "[$(date)] Starting backup: $BACKUP_NAME"

tar czf "$BACKUP_PATH" -C / etc/x-ui root/cert 2>/dev/null || \
tar czf "$BACKUP_PATH" -C / etc/x-ui || \
  { echo "ERROR: Nothing to back up"; exit 1; }

/app/s3.sh put "$BACKUP_PATH" "$BACKUP_NAME"
rm -f "$BACKUP_PATH"
echo "[$(date)] Uploaded $BACKUP_NAME"

# Keep only last 3 backups
BACKUPS=$(/app/s3.sh ls | grep '^backup-.*\.tar\.gz$' | sort)
COUNT=$(echo "$BACKUPS" | wc -l | tr -d ' ')

if [ "$COUNT" -gt 3 ]; then
  DELETE_COUNT=$((COUNT - 3))
  echo "$BACKUPS" | head -n "$DELETE_COUNT" | while read -r f; do
    echo "Deleting old backup: $f"
    /app/s3.sh rm "$f"
  done
fi

echo "[$(date)] Backup complete. Kept latest 3 of $COUNT."
