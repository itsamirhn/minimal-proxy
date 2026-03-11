#!/bin/sh
set -e

for var in S3_ENDPOINT S3_ACCESS_KEY S3_SECRET_KEY S3_BUCKET; do
  eval val=\$$var
  [ -n "$val" ] || { echo "ERROR: $var is required"; exit 1; }
done

# Save env for cron and s3.sh
cat > /app/s3-env.sh <<ENVEOF
export S3_ENDPOINT="$S3_ENDPOINT"
export S3_ACCESS_KEY="$S3_ACCESS_KEY"
export S3_SECRET_KEY="$S3_SECRET_KEY"
export S3_BUCKET="$S3_BUCKET"
export S3_PROXY="${S3_PROXY:-}"
ENVEOF

# Restore latest backup
echo "Looking for latest backup in s3://${S3_BUCKET}..."
LATEST=$(/app/s3.sh ls 2>/dev/null \
  | grep '^backup-.*\.tar\.gz$' \
  | sort \
  | tail -n 1 || true)

if [ -n "$LATEST" ]; then
  echo "Restoring: $LATEST"
  /app/s3.sh get "$LATEST" /tmp/restore.tar.gz
  tar xzf /tmp/restore.tar.gz -C /
  rm -f /tmp/restore.tar.gz
  echo "Restore complete."
else
  echo "No backup found, starting fresh."
fi

# Setup hourly cron
echo "0 * * * * /app/backup.sh >> /var/log/backup.log 2>&1" | crontab -
crond -b
echo "Cron configured for hourly backups."

exec /app/DockerEntrypoint.sh
